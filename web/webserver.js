const http = require("http");
const fs = require('fs');
const ip = require("ip").address();
const host = ip;
const port = 8000;
const path = require('path');
const shell = require('shelljs');

const content = `let ip = "${ip}"`;

/* fs.writeFile('public/js/ip.js', content, err => {
  if (err) {
    console.error(err);
  }
  // file written successfully
}); */

let config = '';
fs.readFile('../config.json', (err, data) => {
    if (err) throw err;
    config = JSON.parse(data);
});


const requestListener = function (req, res){

    if(req.url === "/"){
        fs.readFile("./public/index.html", "UTF-8", function(err, html){
            res.writeHead(200, {"Content-Type": "text/html"});
            res.end(html);
        });

    }else if(req.url.match("\.css$")){
        var cssPath = path.join(__dirname, 'public', req.url);
        var fileStream = fs.createReadStream(cssPath, "UTF-8");
        res.writeHead(200, {"Content-Type": "text/css"});
        fileStream.pipe(res);

    }else if(req.url.match("\.png$")){
        var imagePath = path.join(__dirname, 'public', req.url);
        var fileStream = fs.createReadStream(imagePath);
        res.writeHead(200, {"Content-Type": "image/png"});
        fileStream.pipe(res);

    }else if(req.url.match("\.svg$")){
        var imagePath = path.join(__dirname, 'public', req.url);
        var fileStream = fs.createReadStream(imagePath);
        res.writeHead(200, {"Content-Type": "image/svg+xml"});
        fileStream.pipe(res);

    }else if(req.url.match("\.js$")){
        var jsPath = path.join(__dirname, 'public', req.url);
        var fileStream = fs.createReadStream(jsPath);
        res.writeHead(200);
        fileStream.pipe(res);

    }else if(req.url == "/getinfo"){
        let json = shell.exec('bash ../getinfo.sh',{silent:true});
        json = json.stdout;
        res.setHeader("Content-Type", "application/json")
        res.writeHead(200);
        res.end(json);

    }else if(req.url == "/cli"){
        let json = shell.exec(`bitcoin-cli -datadir=${config.datadir} getblockchaininfo`,{silent:true});
        json = json.stdout;
        res.setHeader("Content-Type", "application/json")
        res.writeHead(200);
        res.end(json);

    }else if(req.url == "/stop"){
        shell.exec('../stop.sh',{silent:false});
        res.setHeader("Content-Type", "application/json")
        res.writeHead(200);
        res.end("");

    }else if(req.url == "/start"){
        shell.exec('../start.sh',{silent:false});
        res.setHeader("Content-Type", "application/json")
        res.writeHead(200);
        res.end("");

    }else if(req.url == "/debug"){
        let debug = shell.exec('./debug.sh',{silent:true});
        // o shell.exec retorna um objeto, ou seja debug é um objeto
        // converter debug de objeto para string
        debug = JSON.stringify(debug);
        res.setHeader("Content-Type", "text/html")
        res.writeHead(200);
        res.end(debug);

    }else{
        res.writeHead(404, {"Content-Type": "text/html"});
        res.end("No Page Found");
    }


};


function openBrowser(){
        shell.exec(`termux-open http://${host}:${port}`);
}

const server = http.createServer(requestListener);
server.listen(port, ip, () => {
        console.log(`Server is running on http://${host}:${port}`);
        console.log();
        console.log(`The browser will open in 5 seconds.`);
        setTimeout(openBrowser, 5000);
});