package com.aloha.login.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.aloha.login.domain.UserAuth;
import com.aloha.login.domain.Users;
import com.aloha.login.mapper.UserMapper;

import jakarta.servlet.http.HttpServletRequest;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private AuthenticationManager authenticationManager;

    @Override
    public boolean insert(Users user) throws Exception {
        // 비밀번호 암호화
        String password = user.getPassword();
        String encodedPassword = passwordEncoder.encode(password);
        user.setPassword(encodedPassword);

        // 회원 등록
        int result = userMapper.join(user);

        // 권한 등록
        if (result > 0) {
            UserAuth userAuth = UserAuth.builder()
                    .username(user.getUsername())
                    .auth("ROLE_USER")
                    .build();
            result += userMapper.insertAuth(userAuth);
        }
        return result > 0;
    }

    @Override
    public Users select(String username) throws Exception {
        return userMapper.select(username);
    }

    @Override
    public void login(Users user, HttpServletRequest request) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'login'");
    }

    @Override
    public boolean update(Users user) throws Exception {
        // 비밀번호 암호화
        // String passwword = user.getPassword();
        // String encodedPassword = passwordEncoder.encode(passwword);
        // user.setPassword(encodedPassword);

        int reuslt = userMapper.update(user);
        return reuslt > 0;
    }

    @Override
    public boolean delete(String username) throws Exception {
        return userMapper.delete(username) > 0;
    }

    @Override
    public Users saveOrLoginGoogleUser(String email, String name) throws Exception {
        System.out.println("이메일 : " + email);
        // 구글 이메일로 사용자 조회
        Users existingUser = userMapper.selectByEmail(email);

        // 사용자가 없으면 새로운 사용자로 등록
        if (existingUser == null) {
            Users newUser = Users.builder()
                    .username(email) // 이메일을 아이디로 사용
                    .email(email)
                    .name(name)
                    .provider("google")
                    .build();

            userMapper.join(newUser);

            // 권한도 등록
            userMapper.insertAuth(UserAuth.builder()
                    .username(newUser.getUsername())
                    .auth("ROLE_USER")
                    .build());

            return newUser;
        }
        // 이미 사용자가 존재하면 그 사용자 반환
        return existingUser;
    }

    @Override
    public Users saveOrLoginNaverUser(String email, String name) throws Exception {
        System.out.println("이메일 : " + email);

        // 네이버 이메일로 사용자 조회
        Users existingUser = userMapper.selectByEmail(email);

        // 사용자가 없으면 새로운 사용자로 등록
        if (existingUser == null) {
            Users newUser = Users.builder()
                    .username(email) // 이메일을 아이디로 사용
                    .email(email)
                    .name(name)
                    .provider("naver")
                    .build();

            userMapper.join(newUser);

            // 권한도 등록
            userMapper.insertAuth(UserAuth.builder()
                    .username(newUser.getUsername())
                    .auth("ROLE_USER")
                    .build());

            return newUser;
        }

        // 이미 사용자가 존재하면 그 사용자 반환
        return existingUser;
    }

    @Override
    public Users saveOrLoginKakaoUser(String id, String name) throws Exception {

        // id로 사용자 조회
        Users existingUser = userMapper.selectById(id);

        // 사용자가 없으면 새로운 사용자로 등록
        if (existingUser == null) {
            Users newUser = Users.builder()
                    .username(name)
                    .name(name)
                    .provider("kakao")
                    .build();

            userMapper.join(newUser);

            // 권한도 등록
            userMapper.insertAuth(UserAuth.builder()
                    .username(newUser.getUsername())
                    .auth("ROLE_USER")
                    .build());

            return newUser;
        }

        // 이미 사용자가 존재하면 그 사용자 반환
        return existingUser;
    }

}
