# FROM golang:1.22 as base

# WORKDIR /app

# #Having COPY go.mod . & RUN go mod download will be usefull when developer team add new dependencies to the the project. Then it will ne included to the project
# COPY go.mod .
# RUN go mod download

# #Copy the source code on to the docker image
# COPY . .

# RUN go build -o main .

# # Final stage - Distroless image

# FROM gcr.io/distroless/base

# #copy the main binary which is in /app directory onto the default directory
# COPY --from=base /app/main .

# #copy the static contents (ex: html, css) to a folder called as static
# #static files are not bundled in the binary (.main). It is outside the binary. Thats why we need to have both static contents as well as the binary in our distrolles image
# COPY --from=base /app/static ./static

# EXPOSE 8080

# CMD [ "./main" ]




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

# Final stage (Distroless)
FROM gcr.io/distroless/static-debian11

COPY --from=base /ijse-go-web-app /

COPY --from=base /ijse-go-web-app/static ./static

EXPOSE 8080

CMD ["/ijse-go-web-app"]