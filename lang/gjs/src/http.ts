// POSTing logic was modified from
// https://github.com/sonnyp/troll/blob/main/src/std/fetch.js

import GObject from 'gi://GObject';
import GLib from "gi://GLib?version=2.0"
import Soup from "gi://Soup?version=3.0";

const { Session, Message } = Soup
const { Bytes, Uri, UriFlags, PRIORITY_DEFAULT } = GLib

type RequestBodyProps = {
  data: Bytes,
  contentType?: string,
}

type RequestProps = {
  method: string,
  headers: Map<string, string>,
}

export class Request {
  protected msg: Message;
  protected sess: Session;
  
  readonly url: string;
  readonly method: string;

  headers: Map<string, string>;

  constructor(url: string, {headers, method}: RequestProps) {
    this.url = url;
    this.headers = headers;
    this.method = method.toUpperCase();
    
    this.sess = new Session();
    this.msg = new Message({
      method: this.method, 
      uri: Uri.parse(url, UriFlags.NONE),
    });
  }

  protected addHeaders() {
    for (let [key, value] of this.headers) {
      this.msg.request_headers.append(key, value);
    }
  }

  async get() {
    this.addHeaders()
    const respBytes = this.sess.send_and_read(this.msg, null);
    return respBytes.get_data() as string;
  }
  
  async post({data, contentType = null}: RequestBodyProps) {
    this.addHeaders() 

    this.msg.set_request_body_from_bytes(
      contentType, 
      new Bytes('{"content":"Some tafsir assignment","project_id":"2319181647"}')
    );

    this.sess.send_async(this.msg, null, null, (_self, result) => {
      this.sess.send_finish(result);
    })
    // (this.msg, PRIORITY_DEFAULT, null, null);
    // return new TextDecoder().decode(respBytes.get_data());
  }
}
