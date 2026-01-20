-- 课程表
create table course
(
    course_id         bigint                not null comment '课程ID' primary key auto_increment,
    title             varchar(255)          not null comment '课程标题',
    description       text                  not null comment '课程描述',
    instructor_id     bigint                not null comment '讲师ID',
    level             enum ('beginner','intermediate','advanced') not null comment '难度级别' default 'beginner',
    duration_hours    int                   not null comment '课程时长（小时）' default 0,
    price             decimal(10,2)         not null comment '课程价格' default 0.00,
    create_time       datetime              not null comment '创建时间' default current_timestamp,
    update_time       datetime              not null comment '更新时间' default current_timestamp on update current_timestamp,
    status            enum ('draft','published','archived') not null comment '课程状态' default 'draft',

    index idx_instructor_id (instructor_id),

    constraint fk_course_instructor
        foreign key (instructor_id)
            references user (uid)
            on delete cascade
) default charset = utf8mb4
  collate = utf8mb4_unicode_ci
  row_format = DYNAMIC comment ='课程目录表';

-- 课程章节表
create table course_section
(
    section_id        bigint                not null comment '章节ID' primary key auto_increment,
    course_id         bigint                not null comment '课程ID',
    title             varchar(255)          not null comment '章节标题',
    order_number      int                   not null comment '章节顺序' default 1,
    description       text                           comment '章节描述',
    estimated_time    int                   not null comment '预计完成时间（分钟）' default 0,

    index idx_course_id (course_id),

    constraint fk_section_course
        foreign key (course_id)
            references course (course_id)
            on delete cascade
) default charset = utf8mb4
  collate = utf8mb4_unicode_ci
  row_format = DYNAMIC comment ='课程章节结构表';

-- 课程内容表
create table course_content
(
    content_id        bigint                not null comment '内容ID' primary key auto_increment,
    section_id        bigint                not null comment '章节ID',
    title             varchar(255)          not null comment '内容标题',
    content_type      enum ('video','text','audio','document') not null comment '内容类型',
    url               varchar(255)                   comment '内容URL',
    content_text      text                           comment '文本内容（如果适用）',
    order_number      int                   not null comment '内容顺序' default 1,

    index idx_section_id (section_id),

    constraint fk_content_section
        foreign key (section_id)
            references course_section (section_id)
            on delete cascade
) default charset = utf8mb4
  collate = utf8mb4_unicode_ci
  row_format = DYNAMIC comment ='课程结构化内容表';

-- 学习路径表
create table learning_path
(
    path_id           bigint                not null comment '路径ID' primary key auto_increment,
    title             varchar(255)          not null comment '路径标题',
    description       text                  not null comment '路径描述',
    career_direction  varchar(255)                   comment '职业方向',
    create_time       datetime              not null comment '创建时间' default current_timestamp,
    update_time       datetime              not null comment '更新时间' default current_timestamp on update current_timestamp
) default charset = utf8mb4
  collate = utf8mb4_unicode_ci
  row_format = DYNAMIC comment ='学习路径/职业方向表';

-- 学习路径-课程关联表
create table learning_path_course
(
    path_id           bigint                not null comment '路径ID',
    course_id         bigint                not null comment '课程ID',
    order_number      int                   not null comment '路径中顺序' default 1,

    primary key (path_id, course_id),

    constraint fk_path_course_path
        foreign key (path_id)
            references learning_path (path_id)
            on delete cascade,
    constraint fk_path_course_course
        foreign key (course_id)
            references course (course_id)
            on delete cascade
) default charset = utf8mb4
  collate = utf8mb4_unicode_ci
  row_format = DYNAMIC comment ='学习路径-课程关联表';

-- 练习表
create table exercise
(
    exercise_id       bigint                not null comment '练习ID' primary key auto_increment,
    course_id         bigint                not null comment '课程ID',
    section_id        bigint                         comment '章节ID（可选）',
    title             varchar(255)          not null comment '练习标题',
    exercise_type     enum ('quiz','assignment','project') not null comment '练习类型',
    description       text                  not null comment '练习描述',
    due_date          datetime                       comment '截止日期',
    max_score         int                   not null comment '满分' default 100,

    index idx_course_id (course_id),
    index idx_section_id (section_id),

    constraint fk_exercise_course
        foreign key (course_id)
            references course (course_id)
            on delete cascade,
    constraint fk_exercise_section
        foreign key (section_id)
            references course_section (section_id)
            on delete cascade
) default charset = utf8mb4
  collate = utf8mb4_unicode_ci
  row_format = DYNAMIC comment ='练习/测验/实操任务表';

-- 提交表
create table submission
(
    submission_id     bigint                not null comment '提交ID' primary key auto_increment,
    exercise_id       bigint                not null comment '练习ID',
    user_id           bigint                not null comment '用户ID',
    content           text                  not null comment '提交内容',
    file_url          varchar(255)                   comment '提交文件URL',
    score             int                            comment '得分',
    feedback          text                           comment '批改反馈',
    submit_time       datetime              not null comment '提交时间' default current_timestamp,
    grade_time        datetime                       comment '批改时间',

    index idx_exercise_id (exercise_id),
    index idx_user_id (user_id),

    constraint fk_submission_exercise
        foreign key (exercise_id)
            references exercise (exercise_id)
            on delete cascade,
    constraint fk_submission_user
        foreign key (user_id)
            references user (uid)
            on delete cascade
) default charset = utf8mb4
  collate = utf8mb4_unicode_ci
  row_format = DYNAMIC comment ='提交/批改记录表';

-- 学习进度表
create table progress
(
    progress_id       bigint                not null comment '进度ID' primary key auto_increment,
    user_id           bigint                not null comment '用户ID',
    course_id         bigint                not null comment '课程ID',
    section_id        bigint                         comment '章节ID（可选）',
    content_id        bigint                         comment '内容ID（可选）',
    completion_status enum ('not_started','in_progress','completed') not null comment '完成状态' default 'not_started',
    progress_percent  int                   not null comment '进度百分比' default 0 check (progress_percent between 0 and 100),
    last_updated      datetime              not null comment '最后更新' default current_timestamp on update current_timestamp,

    unique key uk_user_course (user_id, course_id),

    index idx_user_id (user_id),
    index idx_course_id (course_id),

    constraint fk_progress_user
        foreign key (user_id)
            references user (uid)
            on delete cascade,
    constraint fk_progress_course
        foreign key (course_id)
            references course (course_id)
            on delete cascade,
    constraint fk_progress_section
        foreign key (section_id)
            references course_section (section_id)
            on delete cascade,
    constraint fk_progress_content
        foreign key (content_id)
            references course_content (content_id)
            on delete cascade
) default charset = utf8mb4
  collate = utf8mb4_unicode_ci
  row_format = DYNAMIC comment ='学习进度/完成度追踪表';

-- 错题本表
create table wrong_answer_book
(
    book_id           bigint                not null comment '错题ID' primary key auto_increment,
    user_id           bigint                not null comment '用户ID',
    exercise_id       bigint                not null comment '练习ID',
    submission_id     bigint                         comment '关联提交ID（可选）',
    question_content  text                  not null comment '错题内容',
    correct_answer    text                           comment '正确答案',
    user_answer       text                  not null comment '用户答案',
    note              text                           comment '用户笔记',
    review_count      int                   not null comment '复习次数' default 0,
    last_review_time  datetime                       comment '最后复习时间',
    create_time       datetime              not null comment '创建时间' default current_timestamp,

    index idx_user_id (user_id),
    index idx_exercise_id (exercise_id),
    index idx_create_time (create_time),

    constraint fk_wrong_user
        foreign key (user_id)
            references user (uid)
            on delete cascade,
    constraint fk_wrong_exercise
        foreign key (exercise_id)
            references exercise (exercise_id)
            on delete cascade,
    constraint fk_wrong_submission
        foreign key (submission_id)
            references submission (submission_id)
            on delete cascade
) default charset = utf8mb4
  collate = utf8mb4_unicode_ci
  row_format = DYNAMIC comment ='错题本表';

-- 讲师表
create table instructor
(
    instructor_id     bigint                not null comment '讲师ID' primary key auto_increment,
    user_id           bigint                not null comment '用户ID',
    expertise         varchar(255)                   comment '专长领域',
    bio               text                           comment '讲师简介',
    rating            float                 not null comment '平均评分' default 0 check (rating between 0 and 5),
    courses_count     int                   not null comment '课程数量' default 0,
    create_time       datetime              not null comment '创建时间' default current_timestamp,
    update_time       datetime              not null comment '更新时间' default current_timestamp on update current_timestamp,

    unique key uk_user_id (user_id),

    constraint fk_instructor_user
        foreign key (user_id)
            references user (uid)
            on delete cascade
) default charset = utf8mb4
  collate = utf8mb4_unicode_ci
  row_format = DYNAMIC comment ='讲师/助教/内容创作者后台表';