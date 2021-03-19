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

 Date: 20/03/2021 00:15:15
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
  "password" varchar(255) COLLATE "pg_catalog"."default",
  "phone" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "note" varchar(255) COLLATE "pg_catalog"."default",
  "create_date" varchar(255) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "public"."admin" OWNER TO "postgres";
COMMENT ON COLUMN "public"."admin"."account" IS '账号';
COMMENT ON COLUMN "public"."admin"."password" IS '密码';
COMMENT ON COLUMN "public"."admin"."phone" IS '手机号';
COMMENT ON COLUMN "public"."admin"."note" IS '备注';
COMMENT ON COLUMN "public"."admin"."create_date" IS '创建日期';

-- ----------------------------
-- Records of admin
-- ----------------------------
BEGIN;
INSERT INTO "public"."admin" VALUES (1, 'zhangwuji', 'f492f6a473bdae86915f2940f0d59718', '15201776595', '明教教主', '2021-03-20 00:00:00');
INSERT INTO "public"."admin" VALUES (6, 'linghuchong', 'a64a6d4d6d4f5bbdedb45df84d5cce76', '15201776595', '独孤九剑', '2021-03-13 23:24:28');
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
INSERT INTO "public"."plan" VALUES (2, '令狐冲', '2021-03-14 18:53:01', '', '学独孤九剑', '10%', '进行中');
INSERT INTO "public"."plan" VALUES (3, '石破天', '2021-03-16 00:03:34', '', '学太玄经', '0%', '进行中');
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
INSERT INTO "public"."plan" VALUES (37, 'ruilkyu', '2021-03-19 21:06:10', '', '前端添加 根据文章ID 跳转到指定文章页面模块功能', '1%', '进行中');
COMMIT;

-- ----------------------------
-- Table structure for plan_statistic
-- ----------------------------
DROP TABLE IF EXISTS "public"."plan_statistic";
CREATE TABLE "public"."plan_statistic" (
  "id" int8 DEFAULT nextval('plan_statistic_id_seq'::regclass),
  "statistical_time" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "statistical_running_count" int8,
  "statistical_completed_count" int8
)
;
ALTER TABLE "public"."plan_statistic" OWNER TO "postgres";
COMMENT ON COLUMN "public"."plan_statistic"."statistical_time" IS '统计时间';
COMMENT ON COLUMN "public"."plan_statistic"."statistical_running_count" IS '进行中总数';
COMMENT ON COLUMN "public"."plan_statistic"."statistical_completed_count" IS '已完成总数';

-- ----------------------------
-- Records of plan_statistic
-- ----------------------------
BEGIN;
INSERT INTO "public"."plan_statistic" VALUES (102, '2021-03-19 12:00:01', 5, 26);
INSERT INTO "public"."plan_statistic" VALUES (103, '2021-03-19 12:30:01', 5, 26);
INSERT INTO "public"."plan_statistic" VALUES (8, '2021-03-15', 2, 0);
INSERT INTO "public"."plan_statistic" VALUES (104, '2021-03-19 13:00:01', 5, 26);
INSERT INTO "public"."plan_statistic" VALUES (105, '2021-03-19 13:30:01', 5, 26);
INSERT INTO "public"."plan_statistic" VALUES (106, '2021-03-19 14:00:01', 5, 26);
INSERT INTO "public"."plan_statistic" VALUES (107, '2021-03-19 14:30:01', 5, 26);
INSERT INTO "public"."plan_statistic" VALUES (108, '2021-03-19 15:00:01', 4, 29);
INSERT INTO "public"."plan_statistic" VALUES (109, '2021-03-19 15:30:01', 5, 29);
INSERT INTO "public"."plan_statistic" VALUES (110, '2021-03-19 16:00:01', 4, 31);
INSERT INTO "public"."plan_statistic" VALUES (111, '2021-03-19 16:30:01', 4, 31);
INSERT INTO "public"."plan_statistic" VALUES (9, '2021-03-16', 3, 0);
INSERT INTO "public"."plan_statistic" VALUES (15, '2021-03-16 14:19:00', 3, 4);
INSERT INTO "public"."plan_statistic" VALUES (16, '2021-03-16 14:30:01', 4, 4);
INSERT INTO "public"."plan_statistic" VALUES (20, '2021-03-16 15:00:01', 4, 4);
INSERT INTO "public"."plan_statistic" VALUES (21, '2021-03-16 15:30:01', 3, 5);
INSERT INTO "public"."plan_statistic" VALUES (22, '2021-03-16 16:00:01', 3, 5);
INSERT INTO "public"."plan_statistic" VALUES (23, '2021-03-16 16:30:01', 3, 5);
INSERT INTO "public"."plan_statistic" VALUES (24, '2021-03-16 17:00:01', 3, 5);
INSERT INTO "public"."plan_statistic" VALUES (25, '2021-03-16 17:30:01', 4, 5);
INSERT INTO "public"."plan_statistic" VALUES (26, '2021-03-16 18:00:01', 4, 5);
INSERT INTO "public"."plan_statistic" VALUES (27, '2021-03-16 18:30:01', 4, 5);
INSERT INTO "public"."plan_statistic" VALUES (28, '2021-03-16 19:00:01', 4, 5);
INSERT INTO "public"."plan_statistic" VALUES (29, '2021-03-16 19:30:01', 5, 5);
INSERT INTO "public"."plan_statistic" VALUES (30, '2021-03-16 21:00:01', 5, 5);
INSERT INTO "public"."plan_statistic" VALUES (31, '2021-03-16 21:30:01', 5, 5);
INSERT INTO "public"."plan_statistic" VALUES (32, '2021-03-16 22:00:01', 5, 5);
INSERT INTO "public"."plan_statistic" VALUES (33, '2021-03-17 00:00:01', 5, 5);
INSERT INTO "public"."plan_statistic" VALUES (34, '2021-03-17 09:30:01', 5, 5);
INSERT INTO "public"."plan_statistic" VALUES (35, '2021-03-17 10:00:01', 5, 5);
INSERT INTO "public"."plan_statistic" VALUES (36, '2021-03-17 10:30:01', 5, 5);
INSERT INTO "public"."plan_statistic" VALUES (37, '2021-03-17 11:00:01', 5, 5);
INSERT INTO "public"."plan_statistic" VALUES (38, '2021-03-17 11:30:01', 4, 7);
INSERT INTO "public"."plan_statistic" VALUES (39, '2021-03-17 12:00:01', 3, 9);
INSERT INTO "public"."plan_statistic" VALUES (40, '2021-03-17 12:30:01', 3, 9);
INSERT INTO "public"."plan_statistic" VALUES (41, '2021-03-17 13:00:01', 3, 9);
INSERT INTO "public"."plan_statistic" VALUES (42, '2021-03-17 13:30:01', 3, 9);
INSERT INTO "public"."plan_statistic" VALUES (43, '2021-03-17 14:00:01', 3, 9);
INSERT INTO "public"."plan_statistic" VALUES (44, '2021-03-17 14:30:01', 3, 9);
INSERT INTO "public"."plan_statistic" VALUES (45, '2021-03-17 15:00:01', 3, 9);
INSERT INTO "public"."plan_statistic" VALUES (46, '2021-03-17 15:30:01', 3, 9);
INSERT INTO "public"."plan_statistic" VALUES (47, '2021-03-17 16:00:01', 3, 9);
INSERT INTO "public"."plan_statistic" VALUES (48, '2021-03-17 16:30:01', 4, 9);
INSERT INTO "public"."plan_statistic" VALUES (49, '2021-03-17 17:00:01', 4, 9);
INSERT INTO "public"."plan_statistic" VALUES (50, '2021-03-17 17:30:01', 4, 9);
INSERT INTO "public"."plan_statistic" VALUES (51, '2021-03-17 18:00:01', 5, 9);
INSERT INTO "public"."plan_statistic" VALUES (52, '2021-03-17 18:30:01', 5, 9);
INSERT INTO "public"."plan_statistic" VALUES (53, '2021-03-17 19:00:01', 5, 9);
INSERT INTO "public"."plan_statistic" VALUES (54, '2021-03-18 09:30:01', 5, 9);
INSERT INTO "public"."plan_statistic" VALUES (55, '2021-03-18 10:00:01', 5, 9);
INSERT INTO "public"."plan_statistic" VALUES (56, '2021-03-18 10:30:01', 5, 9);
INSERT INTO "public"."plan_statistic" VALUES (57, '2021-03-18 11:00:01', 5, 9);
INSERT INTO "public"."plan_statistic" VALUES (58, '2021-03-18 11:30:01', 5, 9);
INSERT INTO "public"."plan_statistic" VALUES (59, '2021-03-18 12:00:01', 5, 9);
INSERT INTO "public"."plan_statistic" VALUES (60, '2021-03-18 12:30:01', 5, 9);
INSERT INTO "public"."plan_statistic" VALUES (61, '2021-03-18 13:00:01', 5, 9);
INSERT INTO "public"."plan_statistic" VALUES (62, '2021-03-18 13:30:01', 5, 9);
INSERT INTO "public"."plan_statistic" VALUES (63, '2021-03-18 14:00:01', 5, 9);
INSERT INTO "public"."plan_statistic" VALUES (64, '2021-03-18 16:30:01', 5, 9);
INSERT INTO "public"."plan_statistic" VALUES (65, '2021-03-18 17:00:01', 5, 9);
INSERT INTO "public"."plan_statistic" VALUES (66, '2021-03-18 17:30:01', 5, 10);
INSERT INTO "public"."plan_statistic" VALUES (67, '2021-03-18 18:00:01', 7, 10);
INSERT INTO "public"."plan_statistic" VALUES (68, '2021-03-18 18:30:01', 7, 11);
INSERT INTO "public"."plan_statistic" VALUES (69, '2021-03-18 19:00:01', 3, 15);
INSERT INTO "public"."plan_statistic" VALUES (70, '2021-03-18 19:30:01', 3, 15);
INSERT INTO "public"."plan_statistic" VALUES (71, '2021-03-18 20:00:01', 3, 15);
INSERT INTO "public"."plan_statistic" VALUES (72, '2021-03-18 20:30:01', 5, 15);
INSERT INTO "public"."plan_statistic" VALUES (73, '2021-03-18 21:00:01', 5, 15);
INSERT INTO "public"."plan_statistic" VALUES (74, '2021-03-18 21:30:01', 6, 16);
INSERT INTO "public"."plan_statistic" VALUES (75, '2021-03-18 22:00:01', 6, 16);
INSERT INTO "public"."plan_statistic" VALUES (76, '2021-03-18 22:30:01', 6, 16);
INSERT INTO "public"."plan_statistic" VALUES (77, '2021-03-18 23:00:01', 6, 16);
INSERT INTO "public"."plan_statistic" VALUES (78, '2021-03-18 23:30:01', 6, 16);
INSERT INTO "public"."plan_statistic" VALUES (79, '2021-03-19 00:00:01', 6, 17);
INSERT INTO "public"."plan_statistic" VALUES (80, '2021-03-19 00:30:01', 6, 17);
INSERT INTO "public"."plan_statistic" VALUES (81, '2021-03-19 01:00:01', 6, 17);
INSERT INTO "public"."plan_statistic" VALUES (82, '2021-03-19 01:30:01', 6, 17);
INSERT INTO "public"."plan_statistic" VALUES (83, '2021-03-19 02:00:01', 6, 17);
INSERT INTO "public"."plan_statistic" VALUES (84, '2021-03-19 02:30:01', 6, 17);
INSERT INTO "public"."plan_statistic" VALUES (85, '2021-03-19 03:00:01', 6, 17);
INSERT INTO "public"."plan_statistic" VALUES (86, '2021-03-19 03:30:01', 6, 17);
INSERT INTO "public"."plan_statistic" VALUES (87, '2021-03-19 04:00:01', 6, 17);
INSERT INTO "public"."plan_statistic" VALUES (88, '2021-03-19 04:30:01', 6, 17);
INSERT INTO "public"."plan_statistic" VALUES (89, '2021-03-19 05:00:01', 6, 17);
INSERT INTO "public"."plan_statistic" VALUES (90, '2021-03-19 05:30:01', 6, 17);
INSERT INTO "public"."plan_statistic" VALUES (91, '2021-03-19 06:00:01', 6, 17);
INSERT INTO "public"."plan_statistic" VALUES (92, '2021-03-19 06:30:01', 6, 17);
INSERT INTO "public"."plan_statistic" VALUES (93, '2021-03-19 07:00:01', 6, 17);
INSERT INTO "public"."plan_statistic" VALUES (94, '2021-03-19 07:30:01', 6, 17);
INSERT INTO "public"."plan_statistic" VALUES (95, '2021-03-19 08:00:01', 6, 17);
INSERT INTO "public"."plan_statistic" VALUES (96, '2021-03-19 08:30:01', 6, 17);
INSERT INTO "public"."plan_statistic" VALUES (97, '2021-03-19 09:00:01', 6, 17);
INSERT INTO "public"."plan_statistic" VALUES (98, '2021-03-19 09:30:01', 7, 17);
INSERT INTO "public"."plan_statistic" VALUES (99, '2021-03-19 10:00:01', 8, 17);
INSERT INTO "public"."plan_statistic" VALUES (100, '2021-03-19 10:30:01', 11, 17);
INSERT INTO "public"."plan_statistic" VALUES (101, '2021-03-19 11:00:01', 9, 20);
INSERT INTO "public"."plan_statistic" VALUES (112, '2021-03-19 17:00:01', 4, 31);
INSERT INTO "public"."plan_statistic" VALUES (113, '2021-03-19 17:30:01', 4, 31);
INSERT INTO "public"."plan_statistic" VALUES (114, '2021-03-19 18:00:01', 3, 32);
INSERT INTO "public"."plan_statistic" VALUES (115, '2021-03-19 18:30:01', 3, 32);
INSERT INTO "public"."plan_statistic" VALUES (116, '2021-03-19 19:00:01', 3, 32);
INSERT INTO "public"."plan_statistic" VALUES (117, '2021-03-19 19:30:01', 3, 32);
INSERT INTO "public"."plan_statistic" VALUES (118, '2021-03-19 20:00:01', 4, 32);
INSERT INTO "public"."plan_statistic" VALUES (119, '2021-03-19 20:30:01', 4, 32);
INSERT INTO "public"."plan_statistic" VALUES (120, '2021-03-19 21:00:01', 4, 32);
INSERT INTO "public"."plan_statistic" VALUES (121, '2021-03-19 21:30:01', 4, 33);
INSERT INTO "public"."plan_statistic" VALUES (122, '2021-03-19 22:00:01', 4, 33);
INSERT INTO "public"."plan_statistic" VALUES (123, '2021-03-19 22:30:01', 4, 33);
INSERT INTO "public"."plan_statistic" VALUES (124, '2021-03-19 23:00:01', 4, 33);
INSERT INTO "public"."plan_statistic" VALUES (125, '2021-03-19 23:30:01', 4, 33);
INSERT INTO "public"."plan_statistic" VALUES (126, '2021-03-20 00:00:01', 4, 33);
COMMIT;

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
SELECT setval('"public"."article_id_seq"', 2, false);
SELECT setval('"public"."image_id_seq"', 3, true);
SELECT setval('"public"."plan_id_seq"', 38, true);
SELECT setval('"public"."plan_statistic_id_seq"', 127, true);
SELECT setval('"public"."user_id_seq"', 8, true);

-- ----------------------------
-- Primary Key structure for table admin
-- ----------------------------
ALTER TABLE "public"."admin" ADD CONSTRAINT "admin_pkey" PRIMARY KEY ("id", "account");

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
