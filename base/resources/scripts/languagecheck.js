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
        if (JSON_DATA.locale === lang) {
          return callback(null, "No language switch needed", false);
        }

        JSON_DATA.locale = lang;

        fs.writeFile(
          "/home/jovyan/.config/Code/User/argv.json",
          JSON.stringify(JSON_DATA),
          function (err) {
            if (err) {
              return callback(new Error("Error writing to file:" + err));
            }
            callback(null, "Language file set to:" + lang, true);
          }
        );
      });
    }

    // Set up language for VSCode and Jupyter
    setLanguageJson(function (err, returnMsg, switchLanguage) {
      if (err) {
        createResponse(500,err.toString());
      }
      // Create a string to be used to create the landing page
      let info = returnMsg;

      if (switchLanguage) {
        killJupyterProcesss(function (jupyterError, jupyterResult) {
          if (jupyterError) {
            createResponse(500,jupyterError.toString());
          }
          info = info + "\n" + jupyterResult;
          createResponse(200,info);
        });
      } else {
        createResponse(200,info);
      }
    });

    // Used to create the response on the page and write to the log
    function createResponse(responseCode, responseText){
      console.log(responseText)
      res.writeHead(responseCode, {"Content-Type": "text/plain"});
      res.end(responseText);
    }

    //Used to kill the jupyter process, supervisor will restart it
    function killJupyterProcesss(callback) {
      const { exec } = require("child_process");
      exec("jupyter notebook stop 8090", (error, stdout, stderr) => {
        if (error) {
          return callback(
            new Error(
              "Error executing command stop notebook on 8090:" + error.message
            )
          );
        }
        if (stderr.length > 0) {
          // if something happens during jupyter notebook stop 8090
          return callback(new Error("Command execution error:" + stderr));
        }
        callback(
          null,
          "Restarting Jupyter Notebook to change language:" + stdout
        );
      });
    }
  })
  .listen(42536);

