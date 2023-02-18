migrate-up:
	migrate -path db/migration -database "postgresql://postgres:Vovanhoangtuan1@localhost:5433/simple_bank?sslmode=disable" -verbose up
migrate-down:
	migrate -path db/migration -database "postgresql://postgres:Vovanhoangtuan1@localhost:5433/simple_bank?sslmode=disable" -verbose down
migrate-up-docker:
	docker run --rm -v $(CURDIR)/db/migration:/migrations migrate/migrate -path=/migrations/ -database "postgresql://postgres:Vovanhoangtuan1@host.docker.internal:5433/simple_bank?sslmode=disable" -verbose up
migrate-up-docker-1:
	docker run --rm -v $(CURDIR)/db/migration:/migrations migrate/migrate -path=/migrations/ -database "postgresql://postgres:Vovanhoangtuan1@host.docker.internal:5433/simple_bank?sslmode=disable" -verbose up 1
migrate-down-docker:
	docker run --rm -v $(CURDIR)/db/migration:/migrations migrate/migrate -path=/migrations/ -database "postgresql://postgres:Vovanhoangtuan1@host.docker.internal:5433/simple_bank?sslmode=disable" -verbose down -all
migrate-down-docker-1:
	docker run --rm -v $(CURDIR)/db/migration:/migrations migrate/migrate -path=/migrations/ -database "postgresql://postgres:Vovanhoangtuan1@host.docker.internal:5433/simple_bank?sslmode=disable" -verbose down 1
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

