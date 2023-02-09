migrate-up-docker:
	docker run --rm -v $(CURDIR)/db/migration:/migrations migrate/migrate -path=/migrations/ -database "postgresql://postgres:Vovanhoangtuan1@host.docker.internal:5433/simple_bank?sslmode=disable" -verbose up
migrate-up-docker-1:
	docker run --rm -v $(CURDIR)/db/migration:/migrations migrate/migrate -path=/migrations/ -database "postgresql://postgres:Vovanhoangtuan1@host.docker.internal:5433/simple_bank?sslmode=disable" -verbose up 1
migrate-down-docker:
	docker run --rm -v $(CURDIR)/db/migration:/migrations migrate/migrate -path=/migrations/ -database "postgresql://postgres:Vovanhoangtuan1@host.docker.internal:5433/simple_bank?sslmode=disable" -verbose down -all
migrate-down-docker-1:
	docker run --rm -v $(CURDIR)/db/migration:/migrations migrate/migrate -path=/migrations/ -database "postgresql://postgres:Vovanhoangtuan1@host.docker.internal:5433/simple_bank?sslmode=disable" -verbose down 1
migrate-create:
	docker run --rm -v $(CURDIR)/db/migration:/migrations migrate/migrate -path=/migrations/ create -ext sql -dir migrations -seq add_users
sqlc:
	docker run --rm -v $(CURDIR):/src -w /src kjconroy/sqlc generate
test:
	go test -v -cover ./...
mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/whoant/simple_bank/db/sqlc Store
server:
	go run main.go
