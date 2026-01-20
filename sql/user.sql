-- 用户表
create table user
(
    uid               bigint                not null comment '用户ID' primary key auto_increment,
    user_name         varchar(255)          not null comment '用户名',
    email             varchar(255)          not null comment '电子邮箱' unique,
    password_hash     varchar(64)           not null comment '密码哈希',
    role              enum ('user','instructor','admin') not null comment '用户角色' default 'user',
    create_time       datetime              not null comment '注册时间' default current_timestamp,
    update_time       datetime              not null comment '最后更新时间' default current_timestamp on update current_timestamp,
    level             int                   not null comment '用户级别' default 1,
    experience_points bigint                not null comment '经验值' default 0
) default charset = utf8mb4
  collate = utf8mb4_unicode_ci
  row_format = DYNAMIC comment ='用户表';

-- 用户档案表
create table user_profile
(
    profile_id        bigint                not null comment '档案ID' primary key auto_increment,
    user_id           bigint                not null comment '用户ID',
    bio               text                           comment '个人简介',
    location          varchar(255)                   comment '所在地',
    occupation        varchar(255)                   comment '职业',
    interests         varchar(255)                   comment '兴趣标签（逗号分隔）',
    create_time       datetime              not null comment '创建时间' default current_timestamp,
    update_time       datetime              not null comment '更新时间' default current_timestamp on update current_timestamp,

    unique key uk_user_id (user_id),

    constraint fk_profile_user
        foreign key (user_id)
            references user (uid)
            on delete cascade
) default charset = utf8mb4
  collate = utf8mb4_unicode_ci
  row_format = DYNAMIC comment ='用户成长档案表';

-- 用户成就表
create table user_achievement
(
    achievement_id    bigint                not null comment '成就ID' primary key auto_increment,
    user_id           bigint                not null comment '用户ID',
    title             varchar(255)          not null comment '成就标题',
    description       text                  not null comment '成就描述',
    badge_icon        varchar(255)                   comment '徽章图标URL',
    earned_date       datetime              not null comment '获得时间' default current_timestamp,
    points_awarded    int                   not null comment '奖励积分' default 0,

    index idx_user_id (user_id),

    constraint fk_achievement_user
        foreign key (user_id)
            references user (uid)
            on delete cascade
) default charset = utf8mb4
  collate = utf8mb4_unicode_ci
  row_format = DYNAMIC comment ='用户成就/徽章表';

-- 用户证书表
create table user_certificate
(
    certificate_id    bigint                not null comment '证书ID' primary key auto_increment,
    user_id           bigint                not null comment '用户ID',
    course_id         bigint                         comment '关联课程ID（可选）',
    title             varchar(255)          not null comment '证书标题',
    issue_date        datetime              not null comment '颁发日期' default current_timestamp,
    expiry_date       datetime                       comment '到期日期（可选）',
    certificate_url   varchar(255)                   comment '证书文件URL',

    index idx_user_id (user_id),
    index idx_course_id (course_id),

    constraint fk_certificate_user
        foreign key (user_id)
            references user (uid)
            on delete cascade
) default charset = utf8mb4
  collate = utf8mb4_unicode_ci
  row_format = DYNAMIC comment ='用户证书表';

-- 用户订阅表
create table user_subscription
(
    subscription_id   bigint                not null comment '订阅ID' primary key auto_increment,
    user_id           bigint                not null comment '用户ID',
    plan_type         enum ('free','basic','premium') not null comment '订阅类型' default 'free',
    start_date        datetime              not null comment '开始日期' default current_timestamp,
    end_date          datetime                       comment '结束日期',
    status            enum ('active','expired','canceled') not null comment '订阅状态' default 'active',
    payment_method    varchar(50)                    comment '支付方式',
    coupon_code       varchar(50)                    comment '优惠券代码',

    index idx_user_id (user_id),

    constraint fk_subscription_user
        foreign key (user_id)
            references user (uid)
            on delete cascade
) default charset = utf8mb4
  collate = utf8mb4_unicode_ci
  row_format = DYNAMIC comment ='用户订阅/付费表';
