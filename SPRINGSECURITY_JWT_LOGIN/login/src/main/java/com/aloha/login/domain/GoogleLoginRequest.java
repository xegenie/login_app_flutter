package com.aloha.login.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class GoogleLoginRequest {
    private String email;
    private String name;
}
