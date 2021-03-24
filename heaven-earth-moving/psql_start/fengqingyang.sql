/*
 Navicat Premium Data Transfer

 Source Server         : taiji
 Source Server Type    : PostgreSQL
 Source Server Version : 130002
 Source Host           : 192.168.1.118:5432
 Source Catalog        : taiji
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 130002
 File Encoding         : 65001

 Date: 24/03/2021 14:06:32
*/


-- ----------------------------
-- Sequence structure for article_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."article_id_seq";
CREATE SEQUENCE "public"."article_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "public"."article_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for image_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."image_id_seq";
CREATE SEQUENCE "public"."image_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "public"."image_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for plan_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."plan_id_seq";
CREATE SEQUENCE "public"."plan_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "public"."plan_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for plan_statistic_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."plan_statistic_id_seq";
CREATE SEQUENCE "public"."plan_statistic_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "public"."plan_statistic_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for user_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."user_id_seq";
CREATE SEQUENCE "public"."user_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER SEQUENCE "public"."user_id_seq" OWNER TO "postgres";

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS "public"."admin";
CREATE TABLE "public"."admin" (
  "id" int8 NOT NULL DEFAULT nextval('user_id_seq'::regclass),
  "account" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "password" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "phone" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "note" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "create_date" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "role" varchar(255) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "public"."admin" OWNER TO "postgres";
COMMENT ON COLUMN "public"."admin"."account" IS '账号';
COMMENT ON COLUMN "public"."admin"."password" IS '密码';
COMMENT ON COLUMN "public"."admin"."phone" IS '手机号';
COMMENT ON COLUMN "public"."admin"."note" IS '备注';
COMMENT ON COLUMN "public"."admin"."create_date" IS '创建日期';
COMMENT ON COLUMN "public"."admin"."role" IS '角色';

-- ----------------------------
-- Records of admin
-- ----------------------------
BEGIN;
INSERT INTO "public"."admin" VALUES (1, 'zhangwuji', 'f492f6a473bdae86915f2940f0d59718', '15201776595', '明教教主', '2021-03-20 00:00:00', 'admin_role');
INSERT INTO "public"."admin" VALUES (6, 'linghuchong', 'a64a6d4d6d4f5bbdedb45df84d5cce76', '15201776595', '独孤九剑', '2021-03-13 23:24:28', 'editor_role');
INSERT INTO "public"."admin" VALUES (8, 'ruilkyu', '22c38af1fa77de7c8356b5083a371ce6', '15201776595', '管理员账号', '2021-03-22 10:09:56', 'admin_role');
COMMIT;

-- ----------------------------
-- Table structure for article
-- ----------------------------
DROP TABLE IF EXISTS "public"."article";
CREATE TABLE "public"."article" (
  "article_id" varchar COLLATE "pg_catalog"."default",
  "article_account" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "article_classify" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "article_title" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "article_content" json NOT NULL,
  "article_create_date" varchar(255) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "public"."article" OWNER TO "postgres";
COMMENT ON COLUMN "public"."article"."article_id" IS '文章ID';
COMMENT ON COLUMN "public"."article"."article_account" IS '账户';
COMMENT ON COLUMN "public"."article"."article_classify" IS '分类';
COMMENT ON COLUMN "public"."article"."article_title" IS '标题';
COMMENT ON COLUMN "public"."article"."article_content" IS '内容';
COMMENT ON COLUMN "public"."article"."article_create_date" IS '创建时间';

-- ----------------------------
-- Records of article
-- ----------------------------
BEGIN;
INSERT INTO "public"."article" VALUES ('6778573087333027841', 'linghuchong', '独孤九剑', '破剑式', '{"markdown":"# 风太师叔\n\n![fengtaishishu.jpeg](http://192.168.1.118:8088/images/6778573061923934209.png)"}', '2021-03-19 15:09:23');
INSERT INTO "public"."article" VALUES ('6779937466653741057', 'ruilkyu', '独孤九剑', 'change-your-bone部署', '{"markdown":"::: hljs-center\n\n# change-your-bone部署\n\n:::\n\n\n# 一、技术栈\n\n## 前端：vue+elementui\n## 后端：actix-web(rust)\n\n## 代理：nginx\n## 数据库: postgresql\n\n# 二、具体部署\n## 2.1 、数据库\n### admin表: 账户的具体信息(账号、密码、手机、备注、创建日期、角色等)\n### article表：文章的具体信息(ID、账户、分类、标题、内容、创建时间等)\n### article_classify表：文章的分类信息(ID、分类名等)\n### image_id表：文章和后端存储的图片对应信息(文章ID、图片ID)\n### plan表：制定计划的信息(账户、创建时间、完成时间、备注、进度表、是否完成)\n### plan_statistic表：计划统计信息(统计时间、进行中总数、已完成总数)\n### casbin_rule表：鉴权信息(p_type、v0、v1、v2、v3、v4、v5)\n\n## 2.2、后端\n### 部署目录\n![deploy_dir.png](http://192.168.1.118:8088/images/6779937432415637505.png)\n```\n1、heaven-earth-moving:后端二进制文件(启动方式: ./heaven-earth-moving)\n```\n\n```\n2、qiaofeng.toml:后端 配置文件\n\n[actix_web_config]\nserver = \"0.0.0.0\"\nport = 9000\n\n\n[postgresql_config]\nserver = \"127.0.0.1\"\nport = 5432\nuser = \"taiji\"\npwd = \"zhangsanfeng\"\ndb = \"taiji\"\n\n\n[backend_config]\nhost = \"192.168.1.118\"\nport = 9000\nnginx_host = \"192.168.1.118\"\nnginx_port = 8088\nimages = \"http://192.168.1.118:8088/images/\"\n```\n\n```\n3、psql_start:容器化部署postgresql\n```\n![postgresql_config.png](http://192.168.1.118:8088/images/6780047719630245889.png)\n\n```\n3.1、pv目录:数据持久化目录\n\n3.2、docker-compose.yml:容器编排文件\n\n\nversion: \"3\"\nservices:\n  db:\n    container_name: pg\n    restart: always\n    image: postgres:latest\n    privileged: true\n    ports:\n      - 5432:5432\n    environment:\n      POSTGRES_PASSWORD: 2020Successful!\n      PGDATA: /var/lib/postgresql/data/pgdata\n    volumes:\n      - ./pv:/var/lib/postgresql/data/pgdata\n```\n\n```\n4、casbin:接口鉴权\n```\n![casbin_config.png](http://192.168.1.118:8088/images/6780048518489968641.png)\n\n```\n4.1、rbac_model.conf\n4.2、rbac_policy.csv \n```\n\n5、nginx:容器化部署nginx\n![nginx_config.png](http://192.168.1.118:8088/images/6780049360731377665.png)\n\n```\n5.1、nginx:nginx持久化配置目录\n5.2、static:图片持久化目录\n5.3、docker-compose.yml:容器编排文件\n\nversion: \"2\"\nservices:\n  rustenv:\n    image: nginx\n    container_name: fengqingyang\n    restart: unless-stopped\n    ports:\n    - 8088:80\n    environment:\n    - TZ=Asia/Shanghai\n    volumes:\n    - ./nginx:/etc/nginx\n    - ./static:/root/static\n```"}', '2021-03-23 09:30:57');
COMMIT;

-- ----------------------------
-- Table structure for article_classify
-- ----------------------------
DROP TABLE IF EXISTS "public"."article_classify";
CREATE TABLE "public"."article_classify" (
  "classify_id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "classify_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "public"."article_classify" OWNER TO "postgres";
COMMENT ON COLUMN "public"."article_classify"."classify_id" IS '分类ID';
COMMENT ON COLUMN "public"."article_classify"."classify_name" IS '分类名';

-- ----------------------------
-- Records of article_classify
-- ----------------------------
BEGIN;
INSERT INTO "public"."article_classify" VALUES ('6777786291095474177', '独孤九剑');
INSERT INTO "public"."article_classify" VALUES ('6779930581884080129', '小记');
COMMIT;

-- ----------------------------
-- Table structure for casbin_rule
-- ----------------------------
DROP TABLE IF EXISTS "public"."casbin_rule";
CREATE TABLE "public"."casbin_rule" (
  "p_type" varchar(255) COLLATE "pg_catalog"."default",
  "v0" varchar(255) COLLATE "pg_catalog"."default",
  "v1" varchar(255) COLLATE "pg_catalog"."default",
  "v2" varchar(255) COLLATE "pg_catalog"."default",
  "v3" varchar(255) COLLATE "pg_catalog"."default",
  "v4" varchar(255) COLLATE "pg_catalog"."default",
  "v5" varchar(255) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "public"."casbin_rule" OWNER TO "postgres";

-- ----------------------------
-- Records of casbin_rule
-- ----------------------------
BEGIN;
INSERT INTO "public"."casbin_rule" VALUES ('p', 'get_all_info', '/user', '*', 'allow', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for image_id
-- ----------------------------
DROP TABLE IF EXISTS "public"."image_id";
CREATE TABLE "public"."image_id" (
  "id" int8 NOT NULL DEFAULT nextval('image_id_seq'::regclass),
  "article_id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "article_image_id" varchar(255) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "public"."image_id" OWNER TO "postgres";
COMMENT ON COLUMN "public"."image_id"."article_id" IS '文章ID';
COMMENT ON COLUMN "public"."image_id"."article_image_id" IS '图片ID';

-- ----------------------------
-- Records of image_id
-- ----------------------------
BEGIN;
INSERT INTO "public"."image_id" VALUES (2, '6778573087333027841', '6778573061923934209');
INSERT INTO "public"."image_id" VALUES (3, '6779937466653741057', '6779937432415637505');
INSERT INTO "public"."image_id" VALUES (4, '6779938380697440257', '6779937432415637505');
INSERT INTO "public"."image_id" VALUES (5, '6780045829580394497', '6780045804146135041');
INSERT INTO "public"."image_id" VALUES (6, '6780047010495074305', '6780046985778040833');
INSERT INTO "public"."image_id" VALUES (7, '6780048219750666241', '6780047719630245889');
INSERT INTO "public"."image_id" VALUES (8, '6780048735348068353', '6780048518489968641');
INSERT INTO "public"."image_id" VALUES (9, '6780049977478615041', '6780049360731377665');
COMMIT;

-- ----------------------------
-- Table structure for plan
-- ----------------------------
DROP TABLE IF EXISTS "public"."plan";
CREATE TABLE "public"."plan" (
  "id" int8 NOT NULL DEFAULT nextval('plan_id_seq'::regclass),
  "account" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "create_date" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "completed_date" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "note" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "schedule" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "status" varchar(255) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "public"."plan" OWNER TO "postgres";
COMMENT ON COLUMN "public"."plan"."account" IS '用户';
COMMENT ON COLUMN "public"."plan"."create_date" IS '创建时间';
COMMENT ON COLUMN "public"."plan"."completed_date" IS '完成时间';
COMMENT ON COLUMN "public"."plan"."note" IS '备注';
COMMENT ON COLUMN "public"."plan"."schedule" IS '进度表';
COMMENT ON COLUMN "public"."plan"."status" IS '是否完成(进行中/已完成)';

-- ----------------------------
-- Records of plan
-- ----------------------------
BEGIN;
INSERT INTO "public"."plan" VALUES (22, 'ruilkyu', '2021-03-18 21:18:09', '2021-03-18 21:21:30', '乾坤大挪移 后端数据库 article表 添加 自增序列 CREATE SEQUENCE article_id_seq START 1; nextval(''article_id_seq''::regclass)', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (32, 'ruilkyu', '2021-03-19 14:51:10', '2021-03-19 14:54:23', '后端 数据库 article表添加article_create_date(文章创建时间)', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (20, 'ruilkyu', '2021-03-18 20:02:08', '2021-03-18 23:53:43', '乾坤大挪移 postgresql 添加文章存储数据表', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (4, 'ruilkyu', '2021-03-16 09:10:53', '2021-03-16 10:23:44', '定风珠数据库 expected_time新添规则表ru le', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (5, 'ruilkyu', '2021-03-16 09:29:50', '2021-03-16 10:23:53', '定风珠 后台新添加rule插入接口', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (7, 'ruilkyu', '2021-03-16 10:25:45', '2021-03-16 10:40:13', '定风珠后端 添加 预期rule查询接口', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (6, 'ruilkyu', '2021-03-16 09:57:20', '2021-03-16 10:57:35', '定风珠 前端 添加 阀值页面、添加阀值选项', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (8, 'ruilkyu', '2021-03-16 14:26:32', '2021-03-16 15:16:02', '定风珠 矿池总览 任务数量 p1预期数 后端添加相应接口', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (10, 'ruilkyu', '2021-03-16 19:05:14', '2021-03-17 11:03:23', '乾坤大挪移 后端 添加 创建文章分类、查询文章列表接口', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (9, 'ruilkyu', '2021-03-16 17:06:52', '2021-03-17 11:03:37', '易筋经 添加文章 页面', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (11, 'ruilkyu', '2021-03-17 11:04:38', '2021-03-17 11:36:58', '易筋经前端 添加 分类编辑表单', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (12, 'ruilkyu', '2021-03-17 11:37:40', '2021-03-17 11:37:47', '乾坤大挪移 后端 添加更新文章分类接口', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (24, 'ruilkyu', '2021-03-19 09:09:33', '2021-03-19 10:45:37', '前端 上传文章内容至后端数据库', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (27, 'ruilkyu', '2021-03-19 10:03:56', '2021-03-19 10:45:55', '后端 数据库 设计image_id表', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (15, 'ruilkyu', '2021-03-18 17:08:12', '2021-03-18 17:41:49', '易筋经 前端 小记模块 添加分类', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (17, 'ruilkyu', '2021-03-18 17:59:04', '2021-03-18 18:06:35', 'qiao feng.toml文件新添加[backend_config]模块', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (14, 'ruilkyu', '2021-03-17 17:59:00', '2021-03-18 18:30:03', '前后端 添加支持图片上传回显 功能  1、前端选择图片 2、将图片上传到服务器 3、将图片保存到服务器 4、服务器返回给前端图片地址链接 5、前端回显图片', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (16, 'ruilkyu', '2021-03-18 17:41:34', '2021-03-18 18:30:08', '后端 完善 图片存储接口', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (18, 'ruilkyu', '2021-03-18 18:07:16', '2021-03-18 18:30:14', 'config.rs文件添加backend_config相应序列化和反序列化结构体', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (13, 'ruilkyu', '2021-03-17 16:26:16', '2021-03-18 18:30:23', '前端 画文章编辑页面', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (28, 'ruilkyu', '2021-03-19 10:10:34', '2021-03-19 10:46:05', '后端 UploadImageResponseEntity结构体 添加 镜像ID列', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (21, 'ruilkyu', '2021-03-18 21:08:34', '2021-03-19 11:11:11', '乾坤大挪移 后端增加 创建文章序列化、反序列化结构体', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (19, 'ruilkyu', '2021-03-18 20:01:34', '2021-03-19 11:11:18', '乾坤大挪移 后端 添加文章存储接口', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (23, 'ruilkyu', '2021-03-18 23:54:27', '2021-03-19 11:11:24', '易筋经前端和乾坤大挪移后端 文章存储 对接', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (30, 'ruilkyu', '2021-03-19 11:09:33', '2021-03-19 11:11:29', '乾坤大挪移 后端数据库 article表 添加 自增序列 CREATE SEQUENCE image_id_seq START 1; nextval(''image_id_seq''::regclass)', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (29, 'ruilkyu', '2021-03-19 10:48:06', '2021-03-19 11:11:34', '后端 CreateArticleInfoEntity结构体 添加pub article_image: Vec<String>字段', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (26, 'ruilkyu', '2021-03-19 10:03:40', '2021-03-19 11:11:42', '后端 添加 存储 文章对应图片id 进postgresql的image_id表', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (31, 'ruilkyu', '2021-03-19 11:12:18', '2021-03-19 14:41:20', '乾坤大挪移 后端添加 删除图片接口', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (33, 'ruilkyu', '2021-03-19 14:53:14', '2021-03-19 14:54:16', '后端 CreateArticleInfoEntity结构体 添加pub article_create_date: String字段', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (34, 'ruilkyu', '2021-03-19 15:25:32', '2021-03-19 15:39:12', '后端 添加 文章列表信息接口', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (25, 'ruilkyu', '2021-03-19 09:50:21', '2021-03-19 15:43:22', '前端添加 文章列表展示页', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (35, 'ruilkyu', '2021-03-19 15:51:48', '2021-03-19 17:56:24', '添加 markdown 展示页', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (1, 'zhangwuji', '2021-03-14 15:46:00', ' ', '学九阳神功', '80%', '进行中');
INSERT INTO "public"."plan" VALUES (36, 'ruilkyu', '2021-03-19 19:33:02', '2021-03-19 21:04:59', '乾坤大挪移 后端 添加 根据文章ID返回文章内容 接口', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (37, 'ruilkyu', '2021-03-19 21:06:10', '2021-03-20 00:22:25', '前端添加 根据文章ID 跳转到指定文章页面模块功能', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (2, '令狐冲', '2021-03-14 18:53:01', '', '学独孤九剑', '90%', '进行中');
INSERT INTO "public"."plan" VALUES (3, '石破天', '2021-03-16 00:03:34', '', '学太玄经', '90%', '进行中');
INSERT INTO "public"."plan" VALUES (43, 'ruilkyu', '2021-03-21 21:32:14', '2021-03-22 08:55:04', '后端 login接口 返回值添加角色role字段', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (42, 'ruilkyu', '2021-03-21 12:09:22', '2021-03-22 08:55:11', '后端 数据库 设计 用户角色表', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (41, 'ruilkyu', '2021-03-20 23:42:49', '2021-03-22 08:55:16', 'vue控制不同的用户看到不同的功能', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (44, 'ruilkyu', '2021-03-22 08:58:40', '2021-03-22 10:10:20', '用户 管理 添加 角色展示列', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (45, 'ruilkyu', '2021-03-22 09:30:11', '2021-03-22 10:10:34', '前端 添加管理员 增加角色模块', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (46, 'ruilkyu', '2021-03-22 09:30:30', '2021-03-22 10:10:37', '后端 添加管理员 增加角色类型', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (48, 'ruilkyu', '2021-03-22 13:20:49', '2021-03-22 13:46:43', '后端 添加角色role更改接口', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (47, 'ruilkyu', '2021-03-22 11:15:40', '2021-03-22 13:46:49', '前端 用户管理 权限管理添加 角色role更改功能', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (38, 'ruilkyu', '2021-03-20 00:24:09', '2021-03-22 13:46:58', 'casbin用户权限管理', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (49, 'ruilkyu', '2021-03-22 14:11:47', '2021-03-22 14:11:59', '后端 login接口添加鉴权 并返回token', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (50, 'ruilkyu', '2021-03-22 14:14:03', '2021-03-22 14:14:55', '后端 获取用户信息/user/user_info接口 添加认证和鉴权', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (40, 'ruilkyu', '2021-03-20 19:40:35', '2021-03-22 14:37:29', '后端接口 添加jwt认证', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (39, 'ruilkyu', '2021-03-20 19:35:20', '2021-03-22 14:14:42', 'casbin添加角色 admin_role、editor_role和visitor_role', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (52, 'ruilkyu', '2021-03-22 14:20:35', '2021-03-22 14:27:39', '前端 创建账户 请求体 添加 当前账户的账户名和token', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (51, 'ruilkyu', '2021-03-22 14:15:57', '2021-03-22 14:27:46', '后端 创建账户/user/create_user接口 添加认证和鉴权', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (53, 'ruilkyu', '2021-03-22 14:27:29', '2021-03-22 14:34:03', '后端 删除账户 添加 当前账户的账户名和token', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (54, 'ruilkyu', '2021-03-22 14:27:57', '2021-03-22 14:34:08', '前端 删除账户 添加 当前账户的账户名和token', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (55, 'ruilkyu', '2021-03-22 14:33:29', '2021-03-22 14:37:20', '前端 改变账户角色 添加 当前账户的账户名和token', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (56, 'ruilkyu', '2021-03-22 14:33:56', '2021-03-22 14:37:23', '后端 改变账户角色 /user/change_account_role接口  添加 当前账户的账户名和token', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (57, 'ruilkyu', '2021-03-22 14:39:43', '2021-03-22 14:48:18', '后端获取计划plan信息 /plan/plan_info接口  添加 当前账户的账户名和token', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (58, 'ruilkyu', '2021-03-22 14:40:02', '2021-03-22 14:48:25', '前端获取计划plan信息  添加 当前账户的账户名和token', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (59, 'ruilkyu', '2021-03-22 14:49:53', '2021-03-22 14:55:57', '前端 创建 计划plan 添加 创建账户和相应token', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (60, 'ruilkyu', '2021-03-22 14:50:05', '2021-03-22 14:56:03', '后端 创建 计划plan 添加 创建账户和相应token', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (61, 'ruilkyu', '2021-03-22 15:00:05', '2021-03-22 15:03:27', '前后端 计划plan 调整进度 添加 账户名和token', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (62, 'ruilkyu', '2021-03-22 15:06:49', '2021-03-22 15:12:04', '前后端 获取计划plan统计信息 添加 当前账户和相应的token', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (64, 'ruilkyu', '2021-03-22 15:27:35', '2021-03-22 15:29:26', '前后端 文章分类 模块 添加当前账户及相应token', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (65, 'ruilkyu', '2021-03-22 15:30:30', '2021-03-22 15:33:04', '前后端 创建文章分类 模块 添加当前账户及相应token', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (66, 'ruilkyu', '2021-03-22 15:33:56', '2021-03-22 15:36:30', '前后端 移除文章分类 模块 添加当前账户及相应token', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (67, 'ruilkyu', '2021-03-22 15:40:50', '2021-03-22 15:46:28', '前后端 更新文章分类 模块 添加当前账户及相应token', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (63, 'ruilkyu', '2021-03-22 15:12:53', '2021-03-22 15:58:55', '前后端 获取文章信息 添加 当前账户和相应的token', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (68, 'ruilkyu', '2021-03-22 15:47:47', '2021-03-22 15:58:59', '前后端 创建文章内容 模块 添加当前账户及相应token', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (69, 'ruilkyu', '2021-03-22 16:00:40', '2021-03-22 16:03:27', '前后端 获取文章列表 模块 添加当前账户及相应token', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (70, 'ruilkyu', '2021-03-22 21:53:04', '2021-03-22 21:53:19', '添加 头像 个人信息', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (71, 'ruilkyu', '2021-03-23 09:38:14', '2021-03-23 10:24:23', '前端 小记编写完后 直接跳转展示页', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (72, 'ruilkyu', '2021-03-23 10:29:55', '2021-03-23 16:02:39', '前后端 添加 文章 编辑 功能', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (74, 'ruilkyu', '2021-03-23 10:56:29', '2021-03-23 16:02:44', '后端 根据 插入文章逻辑 修改', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (75, 'ruilkyu', '2021-03-23 14:38:43', '2021-03-23 16:02:52', '前后端 添加 更改密码 功能', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (73, 'ruilkyu', '2021-03-23 10:54:58', '2021-03-23 16:03:00', '前端 小记 添加 根据 路由参数 获取文章内容', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (76, 'ruilkyu', '2021-03-23 16:03:32', '2021-03-23 16:21:55', '前后端 添加 修改 手机号 功能', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (77, 'ruilkyu', '2021-03-23 18:53:19', '2021-03-23 18:53:26', '前端 侧边栏 展示 底色问题', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (78, 'ruilkyu', '2021-03-23 19:23:08', '2021-03-23 20:00:35', '前后端 个人信息模块完善', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (80, 'zhangwuji', '2021-03-23 22:43:08', '', '学 太极剑', '1%', '进行中');
INSERT INTO "public"."plan" VALUES (79, 'ruilkyu', '2021-03-23 20:01:55', '2021-03-24 00:14:16', '前后端 信息 可见度 按账户区分', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (81, 'ruilkyu', '2021-03-24 09:07:19', '2021-03-24 13:34:20', '前后端 添加个人 头像 上传', '100%', '已完成');
INSERT INTO "public"."plan" VALUES (82, 'ruilkyu', '2021-03-24 13:35:01', '', '后端 添加 获取头像uri接口', '10%', '进行中');
COMMIT;

-- ----------------------------
-- Table structure for plan_statistic
-- ----------------------------
DROP TABLE IF EXISTS "public"."plan_statistic";
CREATE TABLE "public"."plan_statistic" (
  "id" int8 DEFAULT nextval('plan_statistic_id_seq'::regclass),
  "statistical_time" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "statistical_running_count" int8,
  "statistical_completed_count" int8,
  "account" varchar(255) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "public"."plan_statistic" OWNER TO "postgres";
COMMENT ON COLUMN "public"."plan_statistic"."statistical_time" IS '统计时间';
COMMENT ON COLUMN "public"."plan_statistic"."statistical_running_count" IS '进行中总数';
COMMENT ON COLUMN "public"."plan_statistic"."statistical_completed_count" IS '已完成总数';
COMMENT ON COLUMN "public"."plan_statistic"."account" IS '账户';

-- ----------------------------
-- Records of plan_statistic
-- ----------------------------
BEGIN;
INSERT INTO "public"."plan_statistic" VALUES (293, '2021-03-23 22:43:14', 1, 75, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (294, '2021-03-23 22:44:19', 1, 75, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (371, '2021-03-24 10:30:01', 1, 0, 'zhangwuji');
INSERT INTO "public"."plan_statistic" VALUES (8, '2021-03-15', 2, 0, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (295, '2021-03-23 23:00:01', 1, 75, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (296, '2021-03-23 23:30:01', 1, 75, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (376, '2021-03-24 11:00:01', 1, 0, 'zhangwuji');
INSERT INTO "public"."plan_statistic" VALUES (297, '2021-03-23 23:46:17', 1, 0, 'zhangwuji');
INSERT INTO "public"."plan_statistic" VALUES (381, '2021-03-24 11:30:01', 1, 0, 'zhangwuji');
INSERT INTO "public"."plan_statistic" VALUES (391, '2021-03-24 12:30:01', 1, 0, 'zhangwuji');
INSERT INTO "public"."plan_statistic" VALUES (401, '2021-03-24 13:30:01', 1, 0, 'zhangwuji');
INSERT INTO "public"."plan_statistic" VALUES (44, '2021-03-17 14:30:01', 3, 9, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (45, '2021-03-17 15:00:01', 3, 9, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (46, '2021-03-17 15:30:01', 3, 9, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (47, '2021-03-17 16:00:01', 3, 9, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (48, '2021-03-17 16:30:01', 4, 9, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (49, '2021-03-17 17:00:01', 4, 9, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (50, '2021-03-17 17:30:01', 4, 9, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (51, '2021-03-17 18:00:01', 5, 9, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (52, '2021-03-17 18:30:01', 5, 9, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (53, '2021-03-17 19:00:01', 5, 9, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (54, '2021-03-18 09:30:01', 5, 9, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (55, '2021-03-18 10:00:01', 5, 9, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (56, '2021-03-18 10:30:01', 5, 9, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (57, '2021-03-18 11:00:01', 5, 9, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (58, '2021-03-18 11:30:01', 5, 9, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (59, '2021-03-18 12:00:01', 5, 9, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (60, '2021-03-18 12:30:01', 5, 9, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (61, '2021-03-18 13:00:01', 5, 9, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (62, '2021-03-18 13:30:01', 5, 9, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (63, '2021-03-18 14:00:01', 5, 9, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (64, '2021-03-18 16:30:01', 5, 9, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (65, '2021-03-18 17:00:01', 5, 9, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (66, '2021-03-18 17:30:01', 5, 10, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (67, '2021-03-18 18:00:01', 7, 10, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (68, '2021-03-18 18:30:01', 7, 11, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (69, '2021-03-18 19:00:01', 3, 15, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (70, '2021-03-18 19:30:01', 3, 15, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (71, '2021-03-18 20:00:01', 3, 15, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (72, '2021-03-18 20:30:01', 5, 15, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (73, '2021-03-18 21:00:01', 5, 15, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (74, '2021-03-18 21:30:01', 6, 16, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (75, '2021-03-18 22:00:01', 6, 16, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (76, '2021-03-18 22:30:01', 6, 16, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (77, '2021-03-18 23:00:01', 6, 16, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (78, '2021-03-18 23:30:01', 6, 16, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (79, '2021-03-19 00:00:01', 6, 17, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (80, '2021-03-19 00:30:01', 6, 17, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (81, '2021-03-19 01:00:01', 6, 17, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (302, '2021-03-24 00:00:01', 1, 0, 'zhangwuji');
INSERT INTO "public"."plan_statistic" VALUES (386, '2021-03-24 12:00:01', 1, 0, 'zhangwuji');
INSERT INTO "public"."plan_statistic" VALUES (307, '2021-03-24 00:30:01', 1, 0, 'zhangwuji');
INSERT INTO "public"."plan_statistic" VALUES (316, '2021-03-24 02:00:01', 1, 0, 'zhangwuji');
INSERT INTO "public"."plan_statistic" VALUES (325, '2021-03-24 03:30:01', 1, 0, 'zhangwuji');
INSERT INTO "public"."plan_statistic" VALUES (334, '2021-03-24 05:00:01', 1, 0, 'zhangwuji');
INSERT INTO "public"."plan_statistic" VALUES (343, '2021-03-24 06:30:01', 1, 0, 'zhangwuji');
INSERT INTO "public"."plan_statistic" VALUES (352, '2021-03-24 08:00:01', 1, 0, 'zhangwuji');
INSERT INTO "public"."plan_statistic" VALUES (396, '2021-03-24 13:00:01', 1, 0, 'zhangwuji');
INSERT INTO "public"."plan_statistic" VALUES (310, '2021-03-24 01:00:01', 1, 0, 'zhangwuji');
INSERT INTO "public"."plan_statistic" VALUES (319, '2021-03-24 02:30:01', 1, 0, 'zhangwuji');
INSERT INTO "public"."plan_statistic" VALUES (406, '2021-03-24 14:00:01', 1, 0, 'zhangwuji');
INSERT INTO "public"."plan_statistic" VALUES (328, '2021-03-24 04:00:01', 1, 0, 'zhangwuji');
INSERT INTO "public"."plan_statistic" VALUES (361, '2021-03-24 09:30:01', 1, 0, 'zhangwuji');
INSERT INTO "public"."plan_statistic" VALUES (337, '2021-03-24 05:30:01', 1, 0, 'zhangwuji');
INSERT INTO "public"."plan_statistic" VALUES (346, '2021-03-24 07:00:01', 1, 0, 'zhangwuji');
INSERT INTO "public"."plan_statistic" VALUES (355, '2021-03-24 08:30:01', 1, 0, 'zhangwuji');
INSERT INTO "public"."plan_statistic" VALUES (366, '2021-03-24 10:00:01', 1, 0, 'zhangwuji');
INSERT INTO "public"."plan_statistic" VALUES (82, '2021-03-19 01:30:01', 6, 17, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (83, '2021-03-19 02:00:01', 6, 17, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (84, '2021-03-19 02:30:01', 6, 17, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (85, '2021-03-19 03:00:01', 6, 17, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (86, '2021-03-19 03:30:01', 6, 17, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (87, '2021-03-19 04:00:01', 6, 17, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (88, '2021-03-19 04:30:01', 6, 17, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (89, '2021-03-19 05:00:01', 6, 17, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (90, '2021-03-19 05:30:01', 6, 17, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (91, '2021-03-19 06:00:01', 6, 17, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (92, '2021-03-19 06:30:01', 6, 17, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (93, '2021-03-19 07:00:01', 6, 17, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (94, '2021-03-19 07:30:01', 6, 17, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (95, '2021-03-19 08:00:01', 6, 17, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (96, '2021-03-19 08:30:01', 6, 17, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (97, '2021-03-19 09:00:01', 6, 17, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (98, '2021-03-19 09:30:01', 7, 17, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (99, '2021-03-19 10:00:01', 8, 17, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (100, '2021-03-19 10:30:01', 11, 17, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (101, '2021-03-19 11:00:01', 9, 20, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (112, '2021-03-19 17:00:01', 4, 31, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (113, '2021-03-19 17:30:01', 4, 31, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (114, '2021-03-19 18:00:01', 3, 32, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (115, '2021-03-19 18:30:01', 3, 32, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (116, '2021-03-19 19:00:01', 3, 32, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (117, '2021-03-19 19:30:01', 3, 32, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (118, '2021-03-19 20:00:01', 4, 32, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (119, '2021-03-19 20:30:01', 4, 32, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (120, '2021-03-19 21:00:01', 4, 32, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (121, '2021-03-19 21:30:01', 4, 33, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (122, '2021-03-19 22:00:01', 4, 33, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (123, '2021-03-19 22:30:01', 4, 33, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (124, '2021-03-19 23:00:01', 4, 33, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (125, '2021-03-19 23:30:01', 4, 33, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (126, '2021-03-20 00:00:01', 4, 33, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (127, '2021-03-20 00:30:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (128, '2021-03-20 01:00:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (129, '2021-03-20 01:30:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (130, '2021-03-20 02:00:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (131, '2021-03-20 02:30:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (132, '2021-03-20 03:00:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (133, '2021-03-20 03:30:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (134, '2021-03-20 04:00:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (135, '2021-03-20 04:30:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (136, '2021-03-20 05:00:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (137, '2021-03-20 05:30:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (138, '2021-03-20 06:00:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (139, '2021-03-20 06:30:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (140, '2021-03-20 07:00:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (141, '2021-03-20 07:30:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (142, '2021-03-20 08:00:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (143, '2021-03-20 08:30:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (144, '2021-03-20 09:00:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (145, '2021-03-20 09:30:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (146, '2021-03-20 10:00:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (147, '2021-03-20 10:30:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (148, '2021-03-20 11:00:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (149, '2021-03-20 11:30:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (150, '2021-03-20 12:00:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (151, '2021-03-20 12:30:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (152, '2021-03-20 13:00:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (153, '2021-03-20 13:30:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (154, '2021-03-20 14:00:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (155, '2021-03-20 14:30:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (156, '2021-03-20 15:00:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (157, '2021-03-20 15:30:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (158, '2021-03-20 16:00:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (159, '2021-03-20 16:30:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (160, '2021-03-20 17:00:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (161, '2021-03-20 17:30:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (162, '2021-03-20 18:00:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (163, '2021-03-20 18:30:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (164, '2021-03-20 19:00:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (165, '2021-03-20 19:30:01', 4, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (166, '2021-03-20 20:00:01', 6, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (167, '2021-03-20 20:30:01', 6, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (168, '2021-03-20 21:00:01', 6, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (169, '2021-03-20 21:30:01', 6, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (170, '2021-03-20 22:00:01', 6, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (171, '2021-03-20 22:30:01', 6, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (172, '2021-03-20 23:00:01', 6, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (173, '2021-03-20 23:30:01', 6, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (174, '2021-03-21 00:00:01', 7, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (175, '2021-03-21 12:00:01', 7, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (176, '2021-03-21 12:30:01', 8, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (177, '2021-03-21 13:00:01', 8, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (178, '2021-03-21 13:30:01', 8, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (179, '2021-03-21 14:00:01', 8, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (180, '2021-03-21 14:30:01', 8, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (181, '2021-03-21 15:00:01', 8, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (182, '2021-03-21 15:30:01', 8, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (183, '2021-03-21 16:00:01', 8, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (184, '2021-03-21 16:30:01', 8, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (185, '2021-03-21 17:00:01', 8, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (186, '2021-03-21 17:30:01', 8, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (187, '2021-03-21 18:00:01', 8, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (188, '2021-03-21 18:30:01', 8, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (189, '2021-03-21 19:00:01', 8, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (190, '2021-03-21 19:30:01', 8, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (191, '2021-03-21 20:00:01', 8, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (192, '2021-03-21 20:30:01', 8, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (193, '2021-03-21 21:00:01', 8, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (194, '2021-03-21 21:30:01', 8, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (195, '2021-03-21 22:00:01', 9, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (196, '2021-03-21 22:30:01', 9, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (197, '2021-03-21 23:00:01', 9, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (198, '2021-03-21 23:30:01', 9, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (199, '2021-03-22 00:00:01', 9, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (200, '2021-03-22 00:30:01', 9, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (201, '2021-03-22 01:00:01', 9, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (202, '2021-03-22 01:30:01', 9, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (203, '2021-03-22 02:00:01', 9, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (204, '2021-03-22 02:30:01', 9, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (205, '2021-03-22 03:00:01', 9, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (206, '2021-03-22 03:30:01', 9, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (207, '2021-03-22 04:00:01', 9, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (208, '2021-03-22 04:30:01', 9, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (209, '2021-03-22 05:00:01', 9, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (210, '2021-03-22 05:30:01', 9, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (211, '2021-03-22 06:00:01', 9, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (212, '2021-03-22 06:30:01', 9, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (213, '2021-03-22 07:00:01', 9, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (214, '2021-03-22 07:30:01', 9, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (215, '2021-03-22 08:00:01', 9, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (216, '2021-03-22 08:30:01', 9, 34, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (217, '2021-03-22 09:00:01', 7, 37, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (218, '2021-03-22 09:30:01', 7, 37, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (219, '2021-03-22 10:00:01', 9, 37, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (220, '2021-03-22 10:30:01', 6, 40, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (221, '2021-03-22 11:00:01', 6, 40, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (222, '2021-03-22 11:30:01', 7, 40, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (223, '2021-03-22 12:00:01', 7, 40, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (224, '2021-03-22 12:30:01', 7, 40, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (225, '2021-03-22 13:00:01', 7, 40, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (226, '2021-03-22 13:30:01', 8, 40, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (227, '2021-03-22 14:00:01', 5, 43, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (228, '2021-03-22 14:30:01', 6, 48, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (229, '2021-03-22 15:00:01', 3, 57, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (258, '2021-03-23 05:30:01', 3, 67, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (259, '2021-03-23 06:00:01', 3, 67, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (260, '2021-03-23 06:30:01', 3, 67, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (261, '2021-03-23 07:00:01', 3, 67, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (262, '2021-03-23 07:30:01', 3, 67, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (263, '2021-03-23 08:00:01', 3, 67, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (264, '2021-03-23 08:30:01', 3, 67, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (265, '2021-03-23 09:00:01', 3, 67, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (266, '2021-03-23 09:30:01', 3, 67, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (267, '2021-03-23 10:00:01', 4, 67, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (268, '2021-03-23 10:30:01', 4, 68, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (269, '2021-03-23 11:00:01', 6, 68, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (270, '2021-03-23 11:30:01', 6, 68, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (271, '2021-03-23 12:00:01', 6, 68, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (103, '2021-03-19 12:30:01', 5, 26, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (104, '2021-03-19 13:00:01', 5, 26, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (105, '2021-03-19 13:30:01', 5, 26, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (106, '2021-03-19 14:00:01', 5, 26, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (107, '2021-03-19 14:30:01', 5, 26, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (108, '2021-03-19 15:00:01', 4, 29, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (109, '2021-03-19 15:30:01', 5, 29, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (110, '2021-03-19 16:00:01', 4, 31, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (111, '2021-03-19 16:30:01', 4, 31, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (9, '2021-03-16', 3, 0, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (15, '2021-03-16 14:19:00', 3, 4, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (16, '2021-03-16 14:30:01', 4, 4, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (20, '2021-03-16 15:00:01', 4, 4, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (21, '2021-03-16 15:30:01', 3, 5, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (22, '2021-03-16 16:00:01', 3, 5, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (23, '2021-03-16 16:30:01', 3, 5, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (24, '2021-03-16 17:00:01', 3, 5, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (25, '2021-03-16 17:30:01', 4, 5, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (26, '2021-03-16 18:00:01', 4, 5, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (27, '2021-03-16 18:30:01', 4, 5, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (28, '2021-03-16 19:00:01', 4, 5, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (29, '2021-03-16 19:30:01', 5, 5, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (30, '2021-03-16 21:00:01', 5, 5, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (31, '2021-03-16 21:30:01', 5, 5, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (32, '2021-03-16 22:00:01', 5, 5, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (33, '2021-03-17 00:00:01', 5, 5, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (34, '2021-03-17 09:30:01', 5, 5, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (35, '2021-03-17 10:00:01', 5, 5, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (36, '2021-03-17 10:30:01', 5, 5, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (37, '2021-03-17 11:00:01', 5, 5, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (38, '2021-03-17 11:30:01', 4, 7, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (39, '2021-03-17 12:00:01', 3, 9, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (40, '2021-03-17 12:30:01', 3, 9, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (41, '2021-03-17 13:00:01', 3, 9, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (42, '2021-03-17 13:30:01', 3, 9, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (43, '2021-03-17 14:00:01', 3, 9, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (272, '2021-03-23 12:30:01', 6, 68, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (273, '2021-03-23 13:00:01', 6, 68, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (274, '2021-03-23 13:30:01', 6, 68, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (275, '2021-03-23 14:00:01', 6, 68, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (276, '2021-03-23 14:30:01', 6, 68, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (277, '2021-03-23 15:00:01', 7, 68, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (278, '2021-03-23 15:30:01', 7, 68, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (279, '2021-03-23 16:00:01', 7, 68, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (280, '2021-03-23 16:30:01', 3, 73, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (281, '2021-03-23 17:00:01', 3, 73, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (282, '2021-03-23 17:30:01', 3, 73, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (283, '2021-03-23 18:00:01', 3, 73, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (284, '2021-03-23 18:30:01', 3, 73, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (285, '2021-03-23 19:00:01', 3, 74, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (286, '2021-03-23 19:30:01', 4, 74, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (287, '2021-03-23 20:00:01', 4, 74, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (288, '2021-03-23 20:30:01', 4, 75, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (289, '2021-03-23 21:00:01', 4, 75, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (290, '2021-03-23 21:30:01', 4, 75, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (291, '2021-03-23 22:00:01', 4, 75, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (102, '2021-03-19 12:00:01', 5, 26, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (230, '2021-03-22 15:30:01', 4, 60, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (231, '2021-03-22 16:00:01', 3, 65, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (232, '2021-03-22 16:30:01', 3, 66, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (233, '2021-03-22 17:00:01', 3, 66, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (234, '2021-03-22 17:30:01', 3, 66, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (235, '2021-03-22 18:00:01', 3, 66, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (236, '2021-03-22 18:30:01', 3, 66, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (237, '2021-03-22 19:00:01', 3, 66, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (238, '2021-03-22 19:30:01', 3, 66, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (239, '2021-03-22 20:00:01', 3, 66, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (240, '2021-03-22 20:30:01', 3, 66, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (241, '2021-03-22 21:00:01', 3, 66, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (242, '2021-03-22 21:30:01', 3, 66, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (243, '2021-03-22 22:00:01', 3, 67, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (244, '2021-03-22 22:30:01', 3, 67, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (245, '2021-03-22 23:00:01', 3, 67, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (246, '2021-03-22 23:30:01', 3, 67, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (247, '2021-03-23 00:00:01', 3, 67, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (248, '2021-03-23 00:30:01', 3, 67, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (249, '2021-03-23 01:00:01', 3, 67, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (250, '2021-03-23 01:30:01', 3, 67, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (251, '2021-03-23 02:00:01', 3, 67, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (252, '2021-03-23 02:30:01', 3, 67, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (253, '2021-03-23 03:00:01', 3, 67, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (254, '2021-03-23 03:30:01', 3, 67, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (255, '2021-03-23 04:00:01', 3, 67, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (256, '2021-03-23 04:30:01', 3, 67, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (257, '2021-03-23 05:00:01', 3, 67, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (292, '2021-03-23 22:40:46', 1, 75, 'ruilkyu');
INSERT INTO "public"."plan_statistic" VALUES (340, '2021-03-24 06:00:01', 1, 0, 'zhangwuji');
INSERT INTO "public"."plan_statistic" VALUES (313, '2021-03-24 01:30:01', 1, 0, 'zhangwuji');
INSERT INTO "public"."plan_statistic" VALUES (322, '2021-03-24 03:00:01', 1, 0, 'zhangwuji');
INSERT INTO "public"."plan_statistic" VALUES (331, '2021-03-24 04:30:01', 1, 0, 'zhangwuji');
INSERT INTO "public"."plan_statistic" VALUES (349, '2021-03-24 07:30:01', 1, 0, 'zhangwuji');
INSERT INTO "public"."plan_statistic" VALUES (358, '2021-03-24 09:00:01', 1, 0, 'zhangwuji');
COMMIT;

-- ----------------------------
-- Table structure for user_image_id
-- ----------------------------
DROP TABLE IF EXISTS "public"."user_image_id";
CREATE TABLE "public"."user_image_id" (
  "account" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "image_id" int8
)
;
ALTER TABLE "public"."user_image_id" OWNER TO "postgres";
COMMENT ON COLUMN "public"."user_image_id"."account" IS '账户';

-- ----------------------------
-- Records of user_image_id
-- ----------------------------
BEGIN;
INSERT INTO "public"."user_image_id" VALUES ('zhangwuji', 6780360700788346881);
INSERT INTO "public"."user_image_id" VALUES ('ruilkyu', 6780366286196183041);
COMMIT;

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
SELECT setval('"public"."article_id_seq"', 2, false);
SELECT setval('"public"."image_id_seq"', 10, true);
SELECT setval('"public"."plan_id_seq"', 83, true);
SELECT setval('"public"."plan_statistic_id_seq"', 411, true);
SELECT setval('"public"."user_id_seq"', 10, true);

-- ----------------------------
-- Primary Key structure for table admin
-- ----------------------------
ALTER TABLE "public"."admin" ADD CONSTRAINT "admin_pkey" PRIMARY KEY ("account");

-- ----------------------------
-- Primary Key structure for table article
-- ----------------------------
ALTER TABLE "public"."article" ADD CONSTRAINT "article_pkey" PRIMARY KEY ("article_account", "article_title");

-- ----------------------------
-- Primary Key structure for table article_classify
-- ----------------------------
ALTER TABLE "public"."article_classify" ADD CONSTRAINT "article_classify_pkey" PRIMARY KEY ("classify_id", "classify_name");

-- ----------------------------
-- Primary Key structure for table image_id
-- ----------------------------
ALTER TABLE "public"."image_id" ADD CONSTRAINT "image_id_pkey" PRIMARY KEY ("id", "article_id");

-- ----------------------------
-- Primary Key structure for table plan
-- ----------------------------
ALTER TABLE "public"."plan" ADD CONSTRAINT "plan_pkey" PRIMARY KEY ("id", "account", "note");

-- ----------------------------
-- Primary Key structure for table plan_statistic
-- ----------------------------
ALTER TABLE "public"."plan_statistic" ADD CONSTRAINT "plan_statisctic_pkey" PRIMARY KEY ("statistical_time");

-- ----------------------------
-- Primary Key structure for table user_image_id
-- ----------------------------
ALTER TABLE "public"."user_image_id" ADD CONSTRAINT "user_image_id_pkey" PRIMARY KEY ("account");
