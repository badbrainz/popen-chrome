#include "picojson.h"
#include "pstream.h"
#include <stdint.h>

void send_message(const std::string& str) {
    uint32_t msglen = str.length();
    std::cout.write(reinterpret_cast<char*>(&msglen), 4);
    std::cout << str << std::flush;
}

int main(int argc, char* argv[]) {
    uint32_t msglen = 0;
    std::cin.read(reinterpret_cast<char*>(&msglen), 4);

    std::string message;
    for (uint32_t i = 0; i < msglen; i++)
        message += getchar();

    picojson::value json;
    const char *msg = message.c_str();
    std::string err = picojson::parse(json, msg, msg + strlen(msg));
    if (!err.empty())
        return 1;

    picojson::value command = json.get("cmd");
    if (!command.is<std::string>())
        return 1;

    redi::ipstream child(command.to_str());
    if (!child.is_open())
        return 1;

    picojson::object response;
    std::string line;
    while (std::getline(child, line)) {
        response["message"] = picojson::value(line);
        send_message(picojson::value(response).serialize());
    }

    return 0;
}
