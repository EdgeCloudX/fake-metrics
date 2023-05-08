FROM golang:1.19 as builder
ENV GOPATH /gopath/
ENV PATH $GOPATH/bin/$PATH

RUN go version
RUN  go env -w GOPROXY=https://goproxy.io,direct
RUN  go env -w GO111MODULE=on

COPY . /go/src/fake_metrics/
WORKDIR /go/src/fake_metrics/

RUN make build

FROM k8s.gcr.io/debian-base:v2.0.0

COPY --from=builder /go/src/fake_metrics /
COPY --from=builder /go/src/fake_metrics/static /static

EXPOSE      8080
ENTRYPOINT  [ "/fake-metrics" ]
