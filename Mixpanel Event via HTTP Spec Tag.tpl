___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Mixpanel Event via HTTP Spec Tag",
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "Send Mixpanel Events via Http Spec via Google Tag Manager Server Side",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "token",
    "displayName": "Project Token",
    "macrosInSelect": true,
    "selectItems": [],
    "simpleValueType": true,
    "help": "Found in Mixpanel under your project info settings"
  },
  {
    "type": "TEXT",
    "name": "event",
    "displayName": "Event Name",
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "ip",
    "displayName": "IP of User",
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "distinct_id",
    "displayName": "Distinct ID",
    "simpleValueType": true,
    "help": "Needs to be a unique id, preferably sent with all events for the user"
  },
  {
    "type": "PARAM_TABLE",
    "name": "parameters",
    "displayName": "Add Parameters",
    "paramTableColumns": [
      {
        "param": {
          "type": "TEXT",
          "name": "name",
          "displayName": "Parameter Name",
          "simpleValueType": true
        },
        "isUnique": false
      },
      {
        "param": {
          "type": "TEXT",
          "name": "value",
          "displayName": "Parameter Value",
          "simpleValueType": true
        },
        "isUnique": false
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

// Enter your template code here.

const getAllEventData = require('getAllEventData');
const sendHttpGet = require('sendHttpGet');
const setResponseHeader = require('setResponseHeader');
const toBase64 = require('toBase64');
const JSON = require('JSON');
const logToConsole = require('logToConsole');
const makeTableMap = require('makeTableMap');

// Get Incoming Event Data
const event = getAllEventData();

// Get template values set by the user
const eventName = data.event;
const projectToken = data.token;
const ipOfUser = data.ip;
const distinct_id = data.distinct_id;

// map out parameters
const params = data.parameters && data.parameters.length ? makeTableMap(data.parameters, 'name', 'value') : {};

// add values to params object
params.distinct_id = distinct_id ;
params.token = projectToken;
params.ip = ipOfUser;

const datajson = {
    "event": eventName,
    "properties": params
};

// Set URL, and use base64 encoding based on their own docs
const url = 'https://api.mixpanel.com/track/?data=' + toBase64(JSON.stringify(datajson));

// Set headers
var headers = {};
headers.referer = event.referer;
headers["user-agent"] = event.user_agent;
headers["x-forwarded-for"] = event.ip_override;

// Send request
sendHttpGet(url, (headers) => {
  setResponseHeader('cache-control', headers['cache-control']);
}, {headers: headers });

// Call data.gtmOnSuccess when the tag is finished.
data.gtmOnSuccess();


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "all"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_event_data",
        "versionId": "1"
      },
      "param": [
        {
          "key": "eventDataAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_response",
        "versionId": "1"
      },
      "param": [
        {
          "key": "writeResponseAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "writeHeaderAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "send_http",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://api.mixpanel.com/track"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Untitled test 1
  code: "const mockData = {\n  // Mocked field values\n  event: \"Test\",\n  token:\
    \ SET_YOUR_TOKEN_HERE,\n  ip: SET_AN_IP_HERE,\n  distinct_id: \"123456789\",\n\
    \  \n  parameters: [{\n    name: '$name',\n    value: 'Ida'\n  },{\n    name:\
    \ '$email',\n    value: 'testtesttesttest@gmail.com'\n  }]\n};\n\n// Call runCode\
    \ to run the template's code.\nrunCode(mockData);\n\n// Verify that the tag finished\
    \ successfully.\nassertApi('gtmOnSuccess').wasCalled();"


___NOTES___

Created on 05/11/2021, 09:51:32
