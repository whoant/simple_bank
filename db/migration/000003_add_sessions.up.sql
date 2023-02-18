CREATE TABLE "sessions" (
    "id" uuid primary key,
    "username" varchar not null,
    "refresh_token" varchar not null,
    "user_agent" varchar not null,
    "client_ip" varchar not null,
    "is_blocked" boolean not null default false,
    "expired_at" timestamptz NOT NULL,
    "created_at" timestamptz NOT NULL DEFAULT (now())
);

alter table "sessions" add foreign key ("username") references "users" ("username");
