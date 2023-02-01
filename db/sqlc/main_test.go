package db

import (
	"database/sql"
	"log"
	"os"
	"testing"

	_ "github.com/lib/pq"
	"github.com/whoant/simple_bank/utils"
)

const (
	dbDriver = "postgres"
	dbSource = "postgresql://postgres:Vovanhoangtuan1@localhost:5433/simple_bank?sslmode=disable"
)

var testQueries *Queries
var testDB *sql.DB

func TestMain(m *testing.M) {
	config, err := utils.LoadConfig("../..")
	if err != nil {
		log.Fatal("cannot load config:", err)
	}

	testDB, err = sql.Open(config.DBDriver, config.DBSource)
	if err != nil {
		log.Fatalf("cannot connect to db : %v", err)
	}

	testQueries = New(testDB)

	os.Exit(m.Run())
}
