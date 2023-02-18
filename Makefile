DB_URL=postgresql://postgres:Vovanhoangtuan1@host.docker.internal:5433/simple_bank?sslmode=disable
DB_URL_TEST=postgresql://postgres:Vovanhoangtuan1@localhost:5433/simple_bank?sslmode=disable

migrate-up:
	migrate -path db/migration -database "$(DB_URL_TEST)" -verbose up
migrate-down:
	migrate -path db/migration -database "$(DB_URL_TEST)" -verbose down
migrate-up-docker:
	docker run --rm -v $(CURDIR)/db/migration:/migrations migrate/migrate -path=/migrations/ -database "$(DB_URL)" -verbose up
migrate-up-docker-1:
	docker run --rm -v $(CURDIR)/db/migration:/migrations migrate/migrate -path=/migrations/ -database "$(DB_URL)" -verbose up 1
migrate-down-docker:
	docker run --rm -v $(CURDIR)/db/migration:/migrations migrate/migrate -path=/migrations/ -database "$(DB_URL)" -verbose down -all
migrate-down-docker-1:
	docker run --rm -v $(CURDIR)/db/migration:/migrations migrate/migrate -path=/migrations/ -database "$(DB_URL)" -verbose down 1
migrate-create:
	docker run --rm -v $PWD/db/migration:/migrations migrate/migrate -path=/migrations/ create -ext sql -dir migrations -seq add_users
sqlc:
	docker run --rm -v $(CURDIR):/src -w /src kjconroy/sqlc generate
test:
	go test -v -cover ./...
mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/whoant/simple_bank/db/sqlc Store
server:
	go run main.go
docker-build:
	docker rmi simple-bank:latest && docker build -t simple-bank:latest .
docker-run:
	docker run --rm --name simple-bank --network=bank-network -p 8080:8080 -e GIN_MODE=release -e DB_SOURCE=postgresql://postgres:Vovanhoangtuan1@postgres:5432/simple_bank?sslmode=disable  simple-bank:latest
db_docs:
	dbdocs build doc/db.dbml
db_schema:
	dbml2sql --postgres -o doc/schema.sql doc/db.dbml
protoc:
	rm -f pb/*.go
	protoc --proto_path=proto --go_out=pb --go_opt=paths=source_relative \
        --go-grpc_out=pb --go-grpc_opt=paths=source_relative \
        proto/*.proto
evnas:
	evans --host localhost --port 9090 -r repl
evans-prod:
	evans --host grpc.vovanhoangtuan.com --port 443 -r repl
