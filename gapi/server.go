package gapi

import (
	"fmt"

	db "github.com/whoant/simple_bank/db/sqlc"
	"github.com/whoant/simple_bank/pb"
	"github.com/whoant/simple_bank/token"
	"github.com/whoant/simple_bank/utils"
	"github.com/whoant/simple_bank/worker"
)

// Server serves gRPC requests for our banking service.
type Server struct {
	pb.UnimplementedSimpleBankServer
	config          utils.Config
	tokenMaker      token.Maker
	store           db.Store
	taskDistributor worker.TaskDistributor
}

// NewServer creates a new gRPC request.
func NewServer(config utils.Config, store db.Store, taskDistributor worker.TaskDistributor) (*Server, error) {
	//tokenMaker, err := token.NewPasetoMaker(config.TokenSymmetricKey)
	tokenMaker, err := token.NewJWTMaker(config.TokenSymmetricKey)
	if err != nil {
		return nil, fmt.Errorf("cannot create token maker: %w", err)
	}
	server := &Server{
		config:          config,
		tokenMaker:      tokenMaker,
		store:           store,
		taskDistributor: taskDistributor,
	}

	return server, nil
}
