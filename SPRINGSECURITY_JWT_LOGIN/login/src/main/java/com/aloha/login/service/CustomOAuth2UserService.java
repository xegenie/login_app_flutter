package com.aloha.login.service;

import java.util.Map;

import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import com.aloha.login.domain.Users;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private final UserService userService;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) {
        OAuth2User oAuth2User = super.loadUser(userRequest);

        // 사용자 정보 추출
        Map<String, Object> attributes = oAuth2User.getAttributes();
        String email = (String) attributes.get("email");
        String name = (String) attributes.get("name");
        String phone = (String) attributes.get("phone");

        // 사용자 저장 또는 업데이트
        try {
            Users user = userService.saveOrLoginGoogleUser(email, name, phone);
        } catch (Exception e) {
            System.err.println("구글 사용자 정보 업데이트 실패");
            e.printStackTrace();
        }

        // 필요한 경우 직접 OAuth2User 구현 객체 반환 가능
        return oAuth2User; // 또는 CustomOAuth2User(user, attributes);
    }
}
