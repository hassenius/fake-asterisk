#!/bin/bash
audiofile="audio_sample_2.wav"
mailbox=$1
voicemail=$2

# Get the nodeports for the services we need
loadgeneratorsrv=$(kubectl get service loadgenerator -o jsonpath={.spec.ports[0].nodePort})
storesrv=$(kubectl get service voicemailstore -o jsonpath={.spec.ports[0].nodePort})

# Upload the audio
curl -i -H "Content-Type:multipart/form-data" -X POST http://mycluster.icp:${storesrv}/api/v1/mailboxes/${mailbox}/voicemails -F file=@stream.part3.wav -F calldata='{"callerid":"+35318562445","duration":"0:10","messageid":"'${voicemail}'","name":"IBM Test","mailbox":"'${mailbox}'","cidnum":"+35318562445","cidname":"","date":"Monday, October 12, 2015 at 10:56:52 AM"};type=application/json'

# Trigger the transcribe service
curl -i -H 'Content-Type: application/json' -X POST http://mycluster.icp:${loadgeneratorsrv}/api/v1/voicemail --data '{"callerid":"+35318562445","duration":"0:10","messageid":"'${voicemail}'","name":"IBM Test","mailbox":"'${mailbox}'","cidnum":"+35318562445","cidname":"","date":"Monday, October 12, 2015 at 10:56:52 AM"}'
