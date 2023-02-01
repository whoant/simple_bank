migrate-up:
	migrate -path db/migration -database "postgresql://postgres:Vovanhoangtuan1@localhost:5433/simple_bank?sslmode=disable" -verbose up
migrate-down:
	migrate -path db/migration -database "postgresql://postgres:Vovanhoangtuan1@localhost:5433/simple_bank?sslmode=disable" -verbose down
migrate-up-docker:
	docker run --rm -v $(CURDIR)/db/migration:/migrations migrate/migrate -path=/migrations/ -database "postgresql://postgres:Vovanhoangtuan1@host.docker.internal:5433/simple_bank?sslmode=disable" -verbose up
migrate-down-docker:
	docker run --rm -v $(CURDIR)/db/migration:/migrations migrate/migrate -path=/migrations/ -database "postgresql://postgres:Vovanhoangtuan1@host.docker.internal:5433/simple_bank?sslmode=disable" -verbose down
sqlc:
	docker run --rm -v $(CURDIR):/src -w /src kjconroy/sqlc generate
test:
	go test -v -cover ./...
server:
	go run main.go
