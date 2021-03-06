<!-- HTML for static distribution bundle build -->
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>Swagger UI</title>
    <link rel="stylesheet" type="text/css" href="./swagger-ui.css" />
    <link
      rel="icon"
      type="image/png"
      href="./favicon-32x32.png"
      sizes="32x32"
    />
    <link
      rel="icon"
      type="image/png"
      href="./favicon-16x16.png"
      sizes="16x16"
    />
    <style>
      html {
        box-sizing: border-box;
        overflow: -moz-scrollbars-vertical;
        overflow-y: scroll;
      }

      *,
      *:before,
      *:after {
        box-sizing: inherit;
      }

      body {
        margin: 0;
        background: #fafafa;
      }

      li {
        list-style-type: none;
      }

      li > a {
        display: inline-block;
        padding: 16px;
        width: 100%;
        background-color: #e9f6f0 !important;
        color: #000;
        text-decoration: none;
        font-size: 18px;
        margin-bottom: 12px;
        border: 1px solid #49cc90;
        border-radius: 4px;
      }

      li > a:hover {
        opacity: 0.9;
        background-color: #eee !important;
      }
      .version > a {
        color: white !important;
      }
      .version > a:hover {
        color: yellow !important;
      }
    </style>
  </head>

  <body>
    <div id="swagger-pre" class="swagger-ui">
      <section class="block col-12">
        <h2><a href="/docs/">{{$.Application}} application services</a></h2>
        <ul>
          {{range $i, $service := .Services}}
          <li>
            <a href="/docs/?url=./proto/{{$service}}/service.swagger.json"
              ><b>{{$service}}</b> - proto/{{$service}}/service.swagger.json</a
            >
          </li>
          {{end}}
        </ul>
      </section>
    </div>

    <div id="swagger-ui"></div>

    <script src="./swagger-ui-bundle.js"></script>
    <script src="./swagger-ui-standalone-preset.js"></script>
    <script>
      window.onload = function () {
        // Begin Swagger UI call region
        const ui = SwaggerUIBundle({
          url: "",
          dom_id: "#swagger-ui",
          deepLinking: true,
          presets: [SwaggerUIBundle.presets.apis, SwaggerUIStandalonePreset],
          plugins: [SwaggerUIBundle.plugins.DownloadUrl],
          layout: "StandaloneLayout",
        });
        // End Swagger UI call region

        window.ui = ui;
      };
    </script>
  </body>
</html>
