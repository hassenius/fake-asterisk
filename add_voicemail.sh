#!/bin/bash
audiofile="stream.part3.wav"
mailbox=$1
voicemail=$2

loadgeneratorsrv=$(kubectl get service loadgenerator -o jsonpath={.spec.ports[0].nodePort})
storesrv=$(kubectl get service voicemailstore -o jsonpath={.spec.ports[0].nodePort})

json='{"callerid":"+35318562445","duration":"0:10","messageid":"'${voicemail}'","name":"IBM Test","mailbox":"'${mailbox}'","cidnum":"+35318562445","cidname":"","date":"Monday, October 12, 2015 at 10:56:52 AM"}'
#;type=application/json'

echo ${json} > post.json
# Upload the audio
#curl -i -H "Content-Type:multipart/form-data" -X POST http://mycluster.icp:${storesrv}/api/v1/mailboxes/${mailbox}/voicemails \
#  -F file=@stream.part3.wav \
#  -F calldata=@post.json
#curl -i -H "Content-Type:multipart/form-data" -X POST http://mycluster.icp:${storesrv}/api/v1/mailboxes/101/voicemails -F file=@stream.part3.wav -F calldata='{"callerid":"+35318562445","duration":"0:10","messageid":"1","name":"IBM Test","mailbox":"101","cidnum":"+35318562445","cidname":"","date":"Monday, October 12, 2015 at 10:56:52 AM"};type=application/json'
curl -i -H "Content-Type:multipart/form-data" -X POST http://mycluster.icp:${storesrv}/api/v1/mailboxes/${mailbox}/voicemails -F file=@stream.part3.wav -F calldata='{"callerid":"+35318562445","duration":"0:10","messageid":"'${voicemail}'","name":"IBM Test","mailbox":"'${mailbox}'","cidnum":"+35318562445","cidname":"","date":"Monday, October 12, 2015 at 10:56:52 AM"};type=application/json'
#curl -i -H "Content-Type:multipart/form-data" -X POST http://mycluster.icp:${storesrv}/api/v1/mailboxes/${mailbox}/voicemails -F file=@stream.part3.wav -F calldata="@post.json;type=application/json"
# Put message on queue to notify arrival of a new voicemail
#curl -i -H 'Content-Type: application/json' -X POST http://mycluster.icp:${loadgeneratorsrv}/api/v1/voicemail --data '{"callerid":"+35318562445","duration":"0:10","messageid":"1","name":"IBM Test","mailbox":"101","cidnum":"+35318562445","cidname":"","date":"Monday, October 12, 2015 at 10:56:52 AM"}'

curl -i -H 'Content-Type: application/json' -X POST http://mycluster.icp:${loadgeneratorsrv}/api/v1/voicemail --data @post.json

