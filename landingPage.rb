def html(dir)
  "<html>
    <head>
        <title>Document</title>
        <link rel='stylesheet' href='./index.css'>
    </head>
    <body>
        <h1 class='title'>Download Server</h1>
        <ul class='files-list'>
            #{dir.map{|f| "<li><a class='link-to-file' href='#{f}' style="'text-decoration: none'">#{f}</a></li>"}.join}
        </ul>
        <p>
        This download server was made using Ruby's TCP Socket and Ngrok for tunelling.
        I implemented a HTTP protocol to comunicate to the server via browser.
        </p>
    </body>
    </html>
  "
end