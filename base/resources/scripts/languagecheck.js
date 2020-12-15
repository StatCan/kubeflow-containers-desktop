/* Nodejs to set up a server on 42536 to modify the argv.json file
   used by in-browser VSCode. Uses the accept-language header.
   Also used by jupyter to determine language.
 */
const http = require("http");
const fs = require("fs");

http
  .createServer(function (req, res) {
    const SUPPORTED_LANGS = ["en", "fr"];
    const DEFAULT_LANG = "en";
    let lang = (req.headers["accept-language"] || DEFAULT_LANG).substring(0, 2);
    if (!SUPPORTED_LANGS.includes(lang)) {
      lang = DEFAULT_LANG;
    }

    function readJsonFile(callback) {
      fs.readFile(
        "/home/jovyan/.config/Code/User/argv.json",
        "utf-8",
        function (err, data) {
          if (err) {
            return callback(new Error("Error when reading file."));
          }
          callback(null, data);
        }
      );
    }

    function setLanguageJson(callback) {
      readJsonFile(function detectLangSwitch(err, content) {
        let JSON_DATA = JSON.parse(content);
        if (JSON_DATA.locale === lang){
          return callback(null, "No language switch needed");
        }
        
        JSON_DATA.locale = lang;

        fs.writeFile(
          "/home/jovyan/.config/Code/User/argv.json",
          JSON.stringify(JSON_DATA),
          function (err) {
            if (err) {
              return callback(new Error("Error writing to file:"+err));
            }
            callback(null, "Language file set to:" + lang);
          }
        );
      });
    }

    setLanguageJson(function (err, returnMsg) {
      if (err){
        console.log(err.toString()); //write to supervisor process
        res.writeHead(500, { "Content-Type": "text/plain" });
        return res.end(err.toString());
      }
      console.log(returnMsg);
      res.writeHead(200, { "Content-Type": "text/plain" });
      res.end(returnMsg);
    });
  })
  .listen(42536);
