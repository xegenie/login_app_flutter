package com.aloha.login.domain;

import java.util.Date;
import java.util.List;
import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@AllArgsConstructor
@Builder
public class Users {
    
    private Long no;
    @Builder.Default
    private String id = UUID.randomUUID().toString();
    private String username;
    private String password;
    private String name;
    private String phone;
    private String email;
    private String provider;
    private Date createdAt;
    private Date updatedAt;
    private Boolean enabled;

    private List<UserAuth> authList;

    public Users() {
        this.id = UUID.randomUUID().toString();
        this.provider = "local";
    }

}
