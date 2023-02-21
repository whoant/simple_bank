FROM golang:1.19-alpine3.16 as builder
WORKDIR /app
COPY . .
RUN go mod tidy
RUN go build -o main main.go

FROM alpine:3.16
WORKDIR /app

COPY --from=builder app/main .
COPY start.sh .
COPY app.env .

EXPOSE 8080
EXPOSE 9090

CMD ["/app/main"]
ENTRYPOINT ["/app/start.sh"]


