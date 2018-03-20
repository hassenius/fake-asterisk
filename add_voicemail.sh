#!/bin/bash
audiofile="stream.part3.wav"
mailbox=$1
voicemail=$2

loadgeneratorsrv=$(kubectl get service loadgenerator -o jsonpath={.spec.ports[0].nodePort})
storesrv=$(kubectl get service voicemailstore -o jsonpath={.spec.ports[0].nodePort})

# Upload the audio
curl -i -H "Content-Type:multipart/form-data" -X POST http://mycluster.icp:${storesrv}/api/v1/mailboxes/${mailbox}/voicemails -F file=@stream.part3.wav -F calldata='{"callerid":"+35318562445","duration":"0:10","messageid":"'${voicemail}'","name":"IBM Test","mailbox":"'${mailbox}'","cidnum":"+35318562445","cidname":"","date":"Monday, October 12, 2015 at 10:56:52 AM"};type=application/json'

# Update the transcript
curl -i -H 'Content-Type: application/json' -X POST http://mycluster.icp:${loadgeneratorsrv}/api/v1/voicemail --data @post.json
