#include <stdint.h>
#include "picojson.h"

using namespace std;

void send_message(const string& str) {
    uint32_t msglen = str.length();
    cout.write(reinterpret_cast<char*>(&msglen), 4);
    cout << str;
}

int main(int argc, char* argv[]) {
    uint32_t msglen = 0;
    cin.read(reinterpret_cast<char*>(&msglen), 4);

    string message;
    for (uint32_t i = 0; i < msglen; i++)
        message += getchar();

    picojson::value json;
    const char *msg = message.c_str();
    string err = picojson::parse(json, msg, msg + strlen(msg));
    if (!err.empty())
        return 1;

    picojson::value command = json.get("cmd");
    if (!command.is<string>())
        return 1;

    FILE* stream = popen(command.to_str().c_str(), "r");
    if (stream == NULL)
        return 1;

    picojson::object result;
    char buffer[1024];
    while (fgets(buffer, 1024, stream) != NULL) {
        result["message"] = picojson::value(buffer);
        send_message(picojson::value(result).serialize());
    }

    pclose(stream);

    return 0;
}
