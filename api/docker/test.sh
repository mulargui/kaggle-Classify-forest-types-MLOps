date +"%T.%3N"
curl -i 127.0.0.1 ; echo
date +"%T.%3N"
curl -X POST -H 'Content-Type: application/json' -d '{"Elevation": 2507.0, "Aspect": 160.0,  "Slope": 8.0 }' http://127.0.0.1/predict/ ; echo
date +"%T.%3N"
curl -X POST -H 'Content-Type: application/json' -d '{"Elevation": 7.0, "Aspect": 160.0,  "Slope": 8.0 }' http://127.0.0.1/predict/ ; echo
date +"%T.%3N"
curl -X POST -H 'Content-Type: application/json' -d '{"Elevation": 2507.0, "Aspect": 1.0,  "Slope": 8.0 }' http://127.0.0.1/predict/ ; echo
date +"%T.%3N"
curl -X POST -H 'Content-Type: application/json' -d '{"Elevation": 2507.0, "Aspect": 160.0,  "Slope": 80.0 }' http://127.0.0.1/predict/ ; echo
date +"%T.%3N"
curl -X POST -H 'Content-Type: application/json' -d '{"Elevation": 7.0, "Aspect": 1.0,  "Slope": 80.0 }' http://127.0.0.1/predict/ ; echo
date +"%T.%3N"
