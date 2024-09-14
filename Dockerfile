
FROM golang:1.22 as base

WORKDIR /go/src/app

#Having COPY go.mod . & RUN go mod tidy will be usefull when developer team add new dependencies to the the project. Then it will ne included to the project
COPY go.mod ./
RUN go mod tidy 
#RUN go get

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o /ijse-go-web-app
# This command will be critical for ensuring that the Go application can run properly in a minimal environment like a Distroless image

RUN  chmod +x /ijse-go-web-app

# Final stage (Distroless)h
FROM gcr.io/distroless/static-debian11

COPY --from=base /ijse-go-web-app /

COPY --from=base /go/src/app/static ./static

EXPOSE 8080

CMD ["/ijse-go-web-app"]
