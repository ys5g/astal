using GLib;

namespace AstalHttp {
public class Request : Object {
  private Soup.Message msg;
  private Soup.Session session;

  public string method { get; set construct; }
  public string url { get; set; }

  public PostBody? body { get; set; default = null; }

  /**
   * @param url The URL to make the request to
   * @param method The HTTP method of the request
   */
  public Request(string url, string method) {
    this.url = url;
    this.method = method;
    this.session = new Soup.Session ();
    this.msg = new Soup.Message (method.up (), url);
  }
  
  /**
   * @param name The key - or name of the header
   * @param value The value of the header
   */
  public void add_header(string name, string value) {
    msg.request_headers.append(name, value);
  }

  /**
   * Synchronously send the request to `this.url`
   */
  public string? call() throws Error {
    switch (this.msg.get_method ()) {
      case "GET":
        var resp_bytes = session.send_and_read (msg);
        return (string) resp_bytes.get_data ();
      case "POST":
        msg.set_request_body_from_bytes (body.content_type, body.bytes);

        var resp_bytes = session.send_and_read (msg);
        return (string) resp_bytes.get_data ();
      default:
        throw new IOError.FAILED(@"Unsupported http request method: $(this.msg.get_method ())");
        return null;
    }
  }
  /**
   * Asynchronously send the request to `this.url`
   */
  public async string? call_async() throws Error {
    switch (this.msg.get_method ()) {
      case "GET":
        var resp_bytes = yield session.send_and_read_async (msg, Priority.DEFAULT, null);
        return (string) resp_bytes.get_data ();
      case "POST":
        msg.set_request_body_from_bytes (body.content_type, body.bytes);

        var resp_bytes = yield session.send_and_read_async (msg, Priority.DEFAULT, null);
        return (string) resp_bytes.get_data ();
      default:
        throw new IOError.FAILED(@"Unsupported http request method: $(this.msg.get_method ())");
        return null;
    }
  }
}
public class PostBody {
  internal Bytes bytes;
  internal string? content_type;

  /**
   * @param bytes An instance of GLib.Bytes that holds the actual request body
   * @param content_type Underlying type of `bytes` before becoming GLib.Bytes, or `null` if unknown
   */
  public PostBody(Bytes bytes, string? content_type = null) {
    this.bytes = bytes;
    this.content_type = content_type;
  }

  /**
   * @param body A stringified json object
   */
  public PostBody.with_json_string(string body) {
    this(new Bytes (body.data), "application/json");
  }
}
}
