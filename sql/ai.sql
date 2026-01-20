-- AI推荐表
create table ai_recommendation
(
    rec_id            bigint                not null comment '推荐ID' primary key auto_increment,
    user_id           bigint                not null comment '用户ID',
    course_id         bigint                         comment '推荐课程ID（可选）',
    path_id           bigint                         comment '推荐路径ID（可选）',
    rec_type          enum ('course','path','exercise') not null comment '推荐类型',
    reason            text                           comment '推荐理由（AI生成）',
    score             float                 not null comment '推荐分数' default 0 check (score between 0 and 100),
    create_time       datetime              not null comment '创建时间' default current_timestamp,
    valid_to          datetime                       comment '有效截止日期',

    index idx_user_id (user_id),
    index idx_rec_type (rec_type),
    index idx_create_time (create_time),

    constraint fk_rec_user
        foreign key (user_id)
            references user (uid)
            on delete cascade,
    constraint fk_rec_course
        foreign key (course_id)
            references course (course_id)
            on delete cascade,
    constraint fk_rec_path
        foreign key (path_id)
            references learning_path (path_id)
            on delete cascade
) default charset = utf8mb4
  collate = utf8mb4_unicode_ci
  row_format = DYNAMIC comment ='AI智能推荐表';

-- AI助手日志表
create table ai_assistant_log
(
    log_id            bigint                not null comment '日志ID' primary key auto_increment,
    user_id           bigint                not null comment '用户ID',
    session_id        varchar(50)           not null comment '会话ID',
    query             text                  not null comment '用户查询',
    response          text                  not null comment 'AI响应',
    create_time       datetime              not null comment '创建时间' default current_timestamp,

    index idx_user_id (user_id),
    index idx_session_id (session_id),
    index idx_create_time (create_time),

    constraint fk_ai_log_user
        foreign key (user_id)
            references user (uid)
            on delete cascade
) default charset = utf8mb4
  collate = utf8mb4_unicode_ci
  row_format = DYNAMIC comment ='AI学习助手记录表';