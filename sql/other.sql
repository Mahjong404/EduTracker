-- 通知表
create table notification
(
    notify_id         bigint                not null comment '通知ID' primary key auto_increment,
    user_id           bigint                not null comment '用户ID',
    title             varchar(100)          not null comment '通知标题',
    content           text                  not null comment '通知内容',
    notify_type       enum ('system','course','community','personal') not null comment '通知类型' default 'system',
    is_read           enum ('Y','N')        not null comment '是否已读' default 'N',
    create_time       datetime              not null comment '创建时间' default current_timestamp,

    index idx_user_id (user_id),
    index idx_notify_type (notify_type),
    index idx_is_read (is_read),
    index idx_create_time (create_time),

    constraint fk_notify_user
        foreign key (user_id)
            references user (uid)
            on delete cascade
) default charset = utf8mb4
  collate = utf8mb4_unicode_ci
  row_format = DYNAMIC comment ='通知/消息/站内信表';

-- 日志表
create table log
(
    log_id            bigint                not null comment '日志ID' primary key auto_increment,
    user_id           bigint                         comment '用户ID（可选）',
    action_type       enum ('login','view_course','submit_exercise','post_comment','ai_query') not null comment '行为类型',
    target_id         varchar(50)                    comment '目标ID（如课程ID、帖子ID）',
    action_desc       varchar(255)          not null comment '行为描述',
    ip_address        varchar(50)                    comment 'IP地址',
    create_time       datetime              not null comment '创建时间' default current_timestamp,

    index idx_user_id (user_id),
    index idx_action_type (action_type),
    index idx_create_time (create_time),

    constraint fk_log_user
        foreign key (user_id)
            references user (uid)
            on delete cascade
) default charset = utf8mb4
  collate = utf8mb4_unicode_ci
  row_format = DYNAMIC comment ='数据埋点/行为日志表';

-- 系统配置表
create table system_config
(
    config_id         bigint                not null comment '配置ID' primary key auto_increment,
    config_key        varchar(100)          not null comment '配置键' unique,
    config_value      varchar(500)          not null comment '配置值',
    config_type       enum ('string','integer','decimal','boolean') not null comment '配置类型' default 'string',
    description       varchar(255)                   comment '配置描述',
    create_time       datetime              not null comment '创建时间' default current_timestamp,
    update_time       datetime              not null comment '更新时间' default current_timestamp on update current_timestamp,

    index idx_config_key (config_key)
) default charset = utf8mb4
  collate = utf8mb4_unicode_ci
  row_format = DYNAMIC comment ='系统配置表';
