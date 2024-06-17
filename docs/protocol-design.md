# Remote LPA Serverr Protocol Design

The protocol runs on TCP, default port is `1888`

Available since eSTK.me 2.1.0 firmware

Official Reference implementation: see [rlpa-Serverr.php](../rlpa-Serverr.php)

## Packet Structure

The is [KLV] format, but length is unsigned short (16 bits, [LE])

[KLV]: https://en.wikipedia.org/wiki/KLV
[LE]: https://en.wikipedia.org/wiki/Endianness

|    Tag | Command                         |
| -----: | ------------------------------- |
| `0x00` | Message Box                     |
| `0x01` | [Remote Managemnt][managed]     |
| `0x02` | [Download Profile][managed]     |
| `0x03` | [Process Notification][managed] |
| `0xFB` | Reboot                          |
| `0xFC` | Close                           |
| `0xFD` | Lock APDU                       |
| `0xFE` | Send APDU Command               |
| `0xFF` | Unlock APDU                     |

[managed]: #managed-function

## Managed function

```mermaid
sequenceDiagram
  autonumber

  actor User
  participant AP
  participant Server
  participant BP
  participant Card as eSTK.me

  User ->> AP: Enable "Cloud Enhance" function
  activate AP
  AP ->> Card: STK interface
  deactivate AP

  User ->> AP: Use Managed function via STK interface
  activate AP
  AP ->> Card: STK interface
  deactivate AP

  activate Card
  Card ->> BP: Establish BIP Channel <br> "Bearer Independent Protocol"
  deactivate Card

  activate BP

  BP ->> Server: Establish TCP Connection
  Note over Server,BP: Accept Connection
  activate Server

  Card ->> BP: Send Command <br> (Tag: 0x01, 0x02 or 0x03)

  opt APDU Interaction
    Server ->> Card: Lock APDU (Tag: 0xFD)

    loop APDU
      Server ->> Card: APDU Request (Tag: 0xFE)
      activate Card
      Card ->> Server: APDU Response (Tag: 0xFE)
      deactivate Card
    end

    Server ->> Card: Unlock APDU (Tag: 0xFF)
  end

  opt Send Message
    Server ->> Card: Send Message Box (Tag: 0x00)
    activate Card

    Card ->> User: Display Message Box
    activate User
    activate AP

    Note right of User: If not click `OK`, all operations are blocked
    User ->> Card: Confirm Message Box

    deactivate Card
    deactivate User
    deactivate AP
  end

  opt Remote Reboot
    Server ->> Card: Reboot (Tag: 0xFB)
    activate Card
    Note left of Card: Reboot the eSTK.me card
    Card ->> BP: Reboot the Card
    deactivate Card
  end

  opt Remote Close
    Server ->> Card: Close (Tag: 0xFC)
    activate Card

    Note left of Card: Close the connection
    Card ->> BP: Close BIP Channel
    deactivate BP
    deactivate Card

    BP -->> Server: Close TCP Connection
    deactivate Server
    Note over BP,Server: May not be sent TCP disconnect
  end

  User -x Card: Disable "Cloud Enhance" function (if need)
```

## References

- [TS.38 STK Device Requirements - UX Enhancements](https://www.gsma.com/newsroom/wp-content/uploads//TS.38-v2.0.pdf)
