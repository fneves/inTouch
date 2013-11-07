CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
CREATE TABLE "admin_users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar(255) DEFAULT '' NOT NULL, "encrypted_password" varchar(255) DEFAULT '' NOT NULL, "reset_password_token" varchar(255), "reset_password_sent_at" datetime, "remember_created_at" datetime, "sign_in_count" integer DEFAULT 0 NOT NULL, "current_sign_in_at" datetime, "last_sign_in_at" datetime, "current_sign_in_ip" varchar(255), "last_sign_in_ip" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE UNIQUE INDEX "index_admin_users_on_email" ON "admin_users" ("email");
CREATE UNIQUE INDEX "index_admin_users_on_reset_password_token" ON "admin_users" ("reset_password_token");
CREATE TABLE "active_admin_comments" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "namespace" varchar(255), "body" text, "resource_id" varchar(255) NOT NULL, "resource_type" varchar(255) NOT NULL, "author_id" integer, "author_type" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE INDEX "index_active_admin_comments_on_namespace" ON "active_admin_comments" ("namespace");
CREATE INDEX "index_active_admin_comments_on_author_type_and_author_id" ON "active_admin_comments" ("author_type", "author_id");
CREATE INDEX "index_active_admin_comments_on_resource_type_and_resource_id" ON "active_admin_comments" ("resource_type", "resource_id");
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar(255) DEFAULT '' NOT NULL, "encrypted_password" varchar(255) DEFAULT '' NOT NULL, "reset_password_token" varchar(255), "reset_password_sent_at" datetime, "remember_created_at" datetime, "sign_in_count" integer DEFAULT 0 NOT NULL, "current_sign_in_at" datetime, "last_sign_in_at" datetime, "current_sign_in_ip" varchar(255), "last_sign_in_ip" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE UNIQUE INDEX "index_users_on_email" ON "users" ("email");
CREATE UNIQUE INDEX "index_users_on_reset_password_token" ON "users" ("reset_password_token");
CREATE TABLE "contact_types" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "descriptor" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "contacts" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "v_address" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE INDEX "index_contacts_on_user_id" ON "contacts" ("user_id");
CREATE TABLE "contact_contact_types" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "contacts_id" integer, "contact_types_id" integer);
INSERT INTO schema_migrations (version) VALUES ('20131106145401');

INSERT INTO schema_migrations (version) VALUES ('20131106145402');

INSERT INTO schema_migrations (version) VALUES ('20131106154356');

INSERT INTO schema_migrations (version) VALUES ('20131107135920');

INSERT INTO schema_migrations (version) VALUES ('20131107144055');

INSERT INTO schema_migrations (version) VALUES ('20131107145211');
