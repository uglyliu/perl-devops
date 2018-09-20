/*
 Navicat Premium Data Transfer

 Source Server         : localhost_postgresql
 Source Server Type    : PostgreSQL
 Source Server Version : 100004
 Source Host           : localhost:5432
 Source Catalog        : postgres
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 100004
 File Encoding         : 65001

 Date: 20/09/2018 18:24:13
*/


-- ----------------------------
-- Table structure for kube_config
-- ----------------------------
DROP TABLE IF EXISTS "public"."kube_config";
CREATE TABLE "public"."kube_config" (
  "id" int4 NOT NULL DEFAULT nextval('kube_config_id_seq'::regclass),
  "kubeName" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "kubeVersion" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "kubeCniVersion" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "etcdVersion" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "dockerVersion" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "netMode" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "clusterIP" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "serviceClusterIP" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "dnsIP" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "dnsDN" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "apiVIP" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "ingressVIP" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "sshUser" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "sshPort" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "masterAddress" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "masterHostName" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "nodeHostName" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "etcdAddress" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "yamlDir" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "nodePort" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "kubeToken" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "loadBalance" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "kubeDesc" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "createDate" timestamp(6) DEFAULT NULL,
  "createUser" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  "updateDate" timestamp(6) DEFAULT NULL,
  "updateUser" varchar COLLATE "pg_catalog"."default" DEFAULT NULL,
  "keepalivedAddress" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL
)
;
COMMENT ON COLUMN "public"."kube_config"."kubeName" IS '集群标识';
COMMENT ON COLUMN "public"."kube_config"."kubeVersion" IS 'k8s版本';
COMMENT ON COLUMN "public"."kube_config"."kubeCniVersion" IS 'CNI版本';
COMMENT ON COLUMN "public"."kube_config"."etcdVersion" IS 'etcd版本';
COMMENT ON COLUMN "public"."kube_config"."dockerVersion" IS 'Docker版本';
COMMENT ON COLUMN "public"."kube_config"."netMode" IS 'k8s网络模型';
COMMENT ON COLUMN "public"."kube_config"."clusterIP" IS 'Cluster IP CIDR';
COMMENT ON COLUMN "public"."kube_config"."serviceClusterIP" IS 'Service Cluster IP CIDR';
COMMENT ON COLUMN "public"."kube_config"."dnsIP" IS 'Service DNS IP CIDR';
COMMENT ON COLUMN "public"."kube_config"."dnsDN" IS 'DNS DN';
COMMENT ON COLUMN "public"."kube_config"."apiVIP" IS 'Kubernetes API VIP';
COMMENT ON COLUMN "public"."kube_config"."ingressVIP" IS 'Kubernetes Ingress VIP';
COMMENT ON COLUMN "public"."kube_config"."sshUser" IS 'SSH用户';
COMMENT ON COLUMN "public"."kube_config"."sshPort" IS 'SSH端口';
COMMENT ON COLUMN "public"."kube_config"."masterAddress" IS 'Master节点地址';
COMMENT ON COLUMN "public"."kube_config"."masterHostName" IS 'Master节点HostName前缀';
COMMENT ON COLUMN "public"."kube_config"."nodeHostName" IS 'Node节点HostName前缀';
COMMENT ON COLUMN "public"."kube_config"."etcdAddress" IS 'etcd集群地址';
COMMENT ON COLUMN "public"."kube_config"."yamlDir" IS 'YAML主目录';
COMMENT ON COLUMN "public"."kube_config"."nodePort" IS 'NodePort端口';
COMMENT ON COLUMN "public"."kube_config"."kubeToken" IS 'token';
COMMENT ON COLUMN "public"."kube_config"."loadBalance" IS '负载均衡器配置';
COMMENT ON COLUMN "public"."kube_config"."kubeDesc" IS '集群描述';
COMMENT ON COLUMN "public"."kube_config"."keepalivedAddress" IS 'keepalived地址';

-- ----------------------------
-- Records of kube_config
-- ----------------------------
INSERT INTO "public"."kube_config" VALUES (1, 'Test', 'v1.11.0', 'v0.7.1', 'v3.3.8', 'v18.05.0-ce', 'Calico-v3.1', '10.244.0.0/16', '10.96.0.0/12', '10.96.0.10', 'cluster.local', '11.11.11.109', '11.11.11.110', 'root', '2222|2200|2201|2202|2203|2204', '11.11.11.11[1-3]', 'k8s-m', 'k8s-n', '11.11.11.11[1-3]', '/root', '8090', NULL, 'HaProxy', '    描述                    
                        ', '2018-09-20 17:59:33', 'admin', NULL, NULL, '11.11.11.11[1-3]');

-- ----------------------------
-- Primary Key structure for table kube_config
-- ----------------------------
ALTER TABLE "public"."kube_config" ADD CONSTRAINT "kube_config_pkey" PRIMARY KEY ("id");
