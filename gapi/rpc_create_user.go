package gapi

import (
	"context"

	"github.com/lib/pq"
	db "github.com/whoant/simple_bank/db/sqlc"
	"github.com/whoant/simple_bank/pb"
	"github.com/whoant/simple_bank/utils"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (server *Server) CreateUser(ctx context.Context, req *pb.CreateUserRequest) (*pb.CreateUserResponse, error) {
	hashedPassword, err := utils.HashPassword(req.GetPassword())
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to hash password : %s", err)
	}

	arg := db.CreateUserParams{
		Username:       req.GetUsername(),
		FullName:       req.GetFullName(),
		Email:          req.GetEmail(),
		HashedPassword: hashedPassword,
	}

	user, err := server.store.CreateUser(ctx, arg)
	if err != nil {
		if pgErr, ok := err.(*pq.Error); ok {
			switch pgErr.Code.Name() {
			case "unique_violation", "users_pkey":
				return nil, status.Errorf(codes.AlreadyExists, "user exists")
			}

		}
		return nil, status.Errorf(codes.Internal, "failed to create user : %s", err)
	}

	var resp = &pb.CreateUserResponse{
		User: convertUser(&user),
	}
	return resp, nil
}
