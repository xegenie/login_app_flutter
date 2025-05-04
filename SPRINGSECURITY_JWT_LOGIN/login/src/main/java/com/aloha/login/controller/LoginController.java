package com.aloha.login.controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.aloha.login.domain.AuthenticationRequest;
import com.aloha.login.domain.GoogleLoginRequest;
import com.aloha.login.domain.Users;
import com.aloha.login.security.constants.SecurityConstants;
import com.aloha.login.security.props.JwtProps;
import com.aloha.login.service.UserService;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;

/**
 * JWT 토큰 생성
 * - 로그인 요청 ➡ 인증 ➡ JWT 토큰 생성
 * 
 * JWT 토큰 해석
 * - 인증 자원 요청 ➡ JWT 토큰 해석
 */

@Slf4j
@RestController
public class LoginController {

    @Autowired
    private JwtProps jwtProps; // secretKey
    @Autowired
    private UserService userService;

    /**
     * 로그인 요청
     * 👩‍💼➡🔐 : 로그인 요청을 통해 인증 시, JWT 토큰 생성
     * 🔗 [POST] - /login
     * 💌 body :
     * {
     * "username" : "aloha",
     * "password" : "123456"
     * }
     * 
     * @param authReq
     * @return
     */
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody AuthenticationRequest authReq) {
        // 아이디 비밀번호
        String username = authReq.getUsername();
        String password = authReq.getPassword();
        log.info("username : " + username);
        log.info("password : " + password);

        // 사용자 권한 정보 세팅
        List<String> roles = new ArrayList<String>();
        roles.add("ROLE_USER");
        roles.add("ROLE_ADMIN");

        // 서명에 사용할 키 생성
        String secretKey = jwtProps.getSecretKey();
        byte[] signingKey = secretKey.getBytes();

        log.info("secretKey : " + secretKey);

        // 💍 JWT 토큰 생성
        // 만료시간 : ms 단위
        // - 5일 : 1000 * 60 * 60 * 24 * 5
        int day5 = 1000 * 60 * 60 * 24 * 5;
        String jwt = Jwts.builder()
                .signWith(Keys.hmacShaKeyFor(signingKey), Jwts.SIG.HS512) // 알고리즘 설정
                .header() // 헤더 설정
                .add("typ", SecurityConstants.TOKEN_TYPE) // typ : "jwt"
                .and() // 페이로드 설정
                .claim("uid", username) // 사용자 아이디
                .claim("rol", roles) // 권한 정보
                .expiration(new Date(System.currentTimeMillis() + day5)) // 만료시간
                .compact(); // 토큰 생성
        log.info("jwt : " + jwt);

        return new ResponseEntity<>(jwt, HttpStatus.OK);

    }

    /**
     * JWT 토큰 해석
     * 💍➡📨 JWT
     * 
     * @param header
     * @return
     */
    @GetMapping("/user")
    public ResponseEntity<?> user(@RequestHeader(name = "Authorization") String authorization) {
        log.info("Authrization : " + authorization);

        // Authrization : "Bearer " + 💍(jwt)
        String jwt = authorization.substring(7);
        log.info("jwt : " + jwt);

        String secretKey = jwtProps.getSecretKey();
        byte[] signingKey = secretKey.getBytes();

        // JWT 토큰 해석 : 💍 ➡ 👩‍💼
        Jws<Claims> parsedToken = Jwts.parser()
                .verifyWith(Keys.hmacShaKeyFor(signingKey))
                .build()
                .parseSignedClaims(jwt);

        String username = parsedToken.getPayload().get("uid").toString();
        log.info("username : " + username);

        Object roles = parsedToken.getPayload().get("rol");
        List<String> roleList = (List<String>) roles;
        log.info("roles : " + roles);
        log.info("roleList : " + roleList);

        return new ResponseEntity<>(parsedToken.toString(), HttpStatus.OK);
    }

    @PostMapping("/google-login")
    public ResponseEntity<?> googleLogin(@RequestBody GoogleLoginRequest request) {
        try {
            String email = request.getEmail();
            String name = request.getName();

            Users user = userService.saveOrLoginGoogleUser(email, name);

            String jwt = createJwtToken(user);

            // 🔥 JWT를 Authorization 헤더에 담아 응답
            return ResponseEntity.ok()
                    .header("Authorization", "Bearer " + jwt)
                    .build();

        } catch (Exception e) {
            return new ResponseEntity<>("구글 로그인 실패: " + e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    /**
     * JWT 토큰 생성
     * 사용자 정보와 함께 JWT 토큰을 생성
     * 
     * @param user
     * @return
     */
    private String createJwtToken(Users user) {
        String secretKey = jwtProps.getSecretKey();
        byte[] signingKey = secretKey.getBytes();

        // 권한 설정 (예시로 ROLE_USER, ROLE_ADMIN 설정)
        List<String> roles = new ArrayList<>();
        roles.add("ROLE_USER");
        roles.add("ROLE_ADMIN");

        // 서명에 사용할 키 생성
        int day5 = 1000 * 60 * 60 * 24 * 5; // 만료시간 (5일)
        return Jwts.builder()
                .signWith(Keys.hmacShaKeyFor(signingKey), Jwts.SIG.HS512) // 알고리즘 설정
                .header() // 헤더 설정
                .add("typ", SecurityConstants.TOKEN_TYPE) // typ : "jwt"
                .and() // 페이로드 설정
                .claim("uid", user.getEmail()) // 사용자 이메일 (아이디)
                .claim("rol", roles) // 권한 정보
                .expiration(new Date(System.currentTimeMillis() + day5)) // 만료시간
                .compact(); // JWT 생성
    }

}
