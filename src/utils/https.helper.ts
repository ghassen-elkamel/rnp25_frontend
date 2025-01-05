import { Injectable, NotFoundException } from "@nestjs/common";

@Injectable()
export class HttpService {
  async login(args: { url: string; username: string; password: string }) {
    let loginResponse = await fetch(args.url, {
      method: "POST",
      headers: this.getHeaders(),

      body: JSON.stringify({
        username: args.username,
        password: args.password,
      }),
    });

    if (loginResponse.status == 200 || loginResponse.status == 201) {
      let jsonLoginResponse = await loginResponse.json();

      if (jsonLoginResponse.token) {
        return jsonLoginResponse.token;
      }
      return jsonLoginResponse;
    } else {
      console.log("***ERROR***");
      console.log("***ERROR[HTTP]***");

      console.log(loginResponse.status);
      console.log(loginResponse.body);

      return new NotFoundException();
    }
  }

  async post(args: { url: string; body: {}; token?: string }) {
    let response = await fetch(args.url, {
      method: "POST",
      headers: this.getHeaders({ token: args.token }),
      body: JSON.stringify(args.body),
    });

    return this.verify(response);
  }

  async get(args: { url: string; token?: string; query?: {}; language?: string }) {
    let queryString = "";
    if (args.query) {
      queryString = new URLSearchParams(args.query).toString();
    }

    let response = await fetch(args.url + queryString, {
      method: "GET",
      headers: this.getHeaders({ token: args.token, language: args.language }),
    });

    return this.verify(response);
  }

  getHeaders(args?: { token?: string; language?: string }) {
    let headers: {} = { "Content-Type": "application/json" };
    if (args?.token) {
      headers["Authorization"] = `Bearer ${args.token}`;
    }
    if (args?.language) {
      headers["Accept-Language"] = args.language;
    }

    return headers;
  }

  async verify(response) {
    if (response.status == 200 || response.status == 201) {
      return await response.json();
    } else {
      return new NotFoundException();
    }
  }
}
