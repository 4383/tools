import argparse
import socket
import socketserver
import ssl

import eventlet


class MyServer(socketserver.BaseRequestHandler):

    def handle(self):
        # self.request is the TCP socket connected to the client
        self.data = self.request.recv(1024).strip()
        print("{} wrote:".format(self.client_address[0]))
        print(self.data)
        # just send back the same data, but upper-cased
        self.request.sendall(self.data.upper())


def client(host, port):
    context = ssl.create_default_context()
    with socket.create_connection((host, port)) as sock:
        with context.wrap_socket(sock, server_hostname=host) as ssock:
            print(ssock.version())


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('type', choices=['server', 'client'])
    parser.add_argument('--host', default='127.0.0.1')
    parser.add_argument('--port', default=8443)
    parser.add_argument('--patched', action='store_true')

    args = parser.parse_args()
    if args.patched:
        print("Monkey patching the stdlib")
        eventlet.monkey_patch()

    if args.type == 'server':
        with socketserver.TCPServer(
                (args.host, args.port), MyServer) as server:
            # Activate the server; this will keep running until you
            # interrupt the program with Ctrl-C
            server.serve_forever()
    else:
        client(args.host, args.port)


if __name__ == "__main__":
    main()
