-- 帖子表
create table post
(
    post_id           bigint                not null comment '帖子ID' primary key auto_increment,
    user_id           bigint                not null comment '用户ID',
    title             varchar(255)          not null comment '帖子标题',
    content           text                  not null comment '帖子内容（Markdown格式）',
    post_type         enum ('question','share','discussion') not null comment '帖子类型' default 'question',
    views             int                   not null comment '浏览量' default 0,
    likes             int                   not null comment '点赞数' default 0,
    create_time       datetime              not null comment '创建时间' default current_timestamp,
    update_time       datetime              not null comment '更新时间' default current_timestamp on update current_timestamp,
    status            enum ('open','closed','deleted') not null comment '帖子状态' default 'open',

    index idx_user_id (user_id),
    index idx_post_type (post_type),
    index idx_create_time (create_time),

    constraint fk_post_user
        foreign key (user_id)
            references user (uid)
            on delete cascade
) default charset = utf8mb4
  collate = utf8mb4_unicode_ci
  row_format = DYNAMIC comment ='社区帖子/问答/经验分享表';

-- 评论表
create table comment
(
    comment_id        bigint                not null comment '评论ID' primary key auto_increment,
    post_id           bigint                not null comment '帖子ID',
    user_id           bigint                not null comment '用户ID',
    content           text                  not null comment '评论内容（Markdown格式）',
    parent_comment_id bigint                         comment '父评论ID（回复）',
    likes             int                   not null comment '点赞数' default 0,
    create_time       datetime              not null comment '创建时间' default current_timestamp,
    update_time       datetime              not null comment '更新时间' default current_timestamp on update current_timestamp,

    index idx_post_id (post_id),
    index idx_user_id (user_id),
    index idx_parent_comment_id (parent_comment_id),
    index idx_create_time (create_time),

    constraint fk_comment_post
        foreign key (post_id)
            references post (post_id)
            on delete cascade,
    constraint fk_comment_user
        foreign key (user_id)
            references user (uid)
            on delete cascade,
    constraint fk_comment_parent
        foreign key (parent_comment_id)
            references comment (comment_id)
            on delete cascade
) default charset = utf8mb4
  collate = utf8mb4_unicode_ci
  row_format = DYNAMIC comment ='帖子评论表';

-- 笔记表
create table note
(
    note_id           bigint                not null comment '笔记ID' primary key auto_increment,
    user_id           bigint                not null comment '用户ID',
    course_id         bigint                         comment '关联课程ID（可选）',
    title             varchar(255)          not null comment '笔记标题',
    content           text                  not null comment '笔记内容（Markdown格式）',
    is_public         enum ('Y','N')        not null comment '是否公开' default 'N',
    create_time       datetime              not null comment '创建时间' default current_timestamp,
    update_time       datetime              not null comment '更新时间' default current_timestamp on update current_timestamp,

    index idx_user_id (user_id),
    index idx_course_id (course_id),
    index idx_create_time (create_time),

    constraint fk_note_user
        foreign key (user_id)
            references user (uid)
            on delete cascade,
    constraint fk_note_course
        foreign key (course_id)
            references course (course_id)
            on delete cascade
) default charset = utf8mb4
  collate = utf8mb4_unicode_ci
  row_format = DYNAMIC comment ='用户笔记表';

-- 标签表
create table tag
(
    tag_id            bigint                not null comment '标签ID' primary key auto_increment,
    tag_name          varchar(50)           not null comment '标签名称' unique,
    tag_color         varchar(20)                    comment '标签颜色（用于前端显示）',
    description       varchar(255)                   comment '标签描述',
    use_count         int                   not null comment '使用次数' default 0,
    create_time       datetime              not null comment '创建时间' default current_timestamp,

    index idx_tag_name (tag_name),
    index idx_use_count (use_count)
) default charset = utf8mb4
  collate = utf8mb4_unicode_ci
  row_format = DYNAMIC comment ='标签表';

-- 帖子-标签关联表
create table post_tag
(
    post_id           bigint                not null comment '帖子ID',
    tag_id            bigint                not null comment '标签ID',

    primary key (post_id, tag_id),

    constraint fk_post_tag_post
        foreign key (post_id)
            references post (post_id)
            on delete cascade,
    constraint fk_post_tag_tag
        foreign key (tag_id)
            references tag (tag_id)
            on delete cascade
) default charset = utf8mb4
  collate = utf8mb4_unicode_ci
  row_format = DYNAMIC comment ='帖子-标签关联表';

-- 课程-标签关联表
create table course_tag
(
    course_id         bigint                not null comment '课程ID',
    tag_id            bigint                not null comment '标签ID',

    primary key (course_id, tag_id),

    constraint fk_course_tag_course
        foreign key (course_id)
            references course (course_id)
            on delete cascade,
    constraint fk_course_tag_tag
        foreign key (tag_id)
            references tag (tag_id)
            on delete cascade
) default charset = utf8mb4
  collate = utf8mb4_unicode_ci
  row_format = DYNAMIC comment ='课程-标签关联表';
