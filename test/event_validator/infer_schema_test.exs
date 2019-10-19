defmodule EventValidator.Events.InferSchemaTest do
  use EventValidator.DataCase

  alias EventValidator.Events.InferSchema

  @event_map %{
    "event_params" => %{
      "_metadata" => %{
        "bundled" => ["Segment.io"],
        "unbundled" => []
      },
      "anonymousId" => "59407d67-a829-424a-a6c6-b8dc1ccbfde5",
      "channel" => "client",
      "context" => %{
        "ip" => "186.228.210.10",
        "library" => %{"name" => "analytics.js", "version" => "3.9.0"},
        "page" => %{
          "path" => "/login",
          "referrer" => "https://05310947.ngrok.io/organizations",
          "search" => "",
          "title" => "login",
          "url" => "https://05310947.ngrok.io/login"
        },
        "userAgent" =>
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36"
      },
      "event" => "invalid event",
      "integrations" => %{},
      "messageId" => "ajs-a11751cec0ebb7ddf26ce32bf236c4eb",
      "originalTimestamp" => "2019-10-14T23:15:30.079Z",
      "projectId" => "nAAqhQIKtw",
      "properties" => %{"email" => "lui@mag.com", "userId" => "10"},
      "receivedAt" => "2019-10-14T23:15:30.202Z",
      "sentAt" => "2019-10-14T23:15:30.082Z",
      "timestamp" => "2019-10-14T23:15:30.199Z",
      "type" => "track",
      "userId" => nil,
      "version" => 2
    }
  }

  describe "infer schema" do
    test "infer/1 infer JSON schema for map" do
      infered_schema = InferSchema.infer(@event_map)

      assert infered_schema == %{
               "$schema" => "http://json-schema.org/draft-04/schema#",
               "type" => "object",
               "required" => [
                 "_metadata",
                 "anonymousId",
                 "channel",
                 "context",
                 "event",
                 "integrations",
                 "messageId",
                 "originalTimestamp",
                 "projectId",
                 "properties",
                 "receivedAt",
                 "sentAt",
                 "timestamp",
                 "type",
                 "version"
               ],
               "properties" => %{
                 "_metadata" => %{
                   "type" => "object",
                   "required" => [
                     "bundled",
                     "unbundled"
                   ],
                   "properties" => %{
                     "bundled" => %{
                       "type" => "array",
                       "items" => %{
                         "type" => "string",
                         "examples" => [
                           "Segment.io"
                         ]
                       }
                     },
                     "unbundled" => %{
                       "type" => "array"
                     }
                   }
                 },
                 "anonymousId" => %{
                   "type" => "string",
                   "examples" => [
                     "59407d67-a829-424a-a6c6-b8dc1ccbfde5"
                   ]
                 },
                 "channel" => %{
                   "type" => "string",
                   "examples" => [
                     "client"
                   ]
                 },
                 "context" => %{
                   "type" => "object",
                   "required" => [
                     "ip",
                     "library",
                     "page",
                     "userAgent"
                   ],
                   "properties" => %{
                     "ip" => %{
                       "type" => "string",
                       "examples" => [
                         "186.228.210.10"
                       ]
                     },
                     "library" => %{
                       "type" => "object",
                       "required" => [
                         "name",
                         "version"
                       ],
                       "properties" => %{
                         "name" => %{
                           "type" => "string",
                           "examples" => [
                             "analytics.js"
                           ]
                         },
                         "version" => %{
                           "type" => "string",
                           "examples" => [
                             "3.9.0"
                           ]
                         }
                       }
                     },
                     "page" => %{
                       "type" => "object",
                       "required" => [
                         "path",
                         "referrer",
                         "search",
                         "title",
                         "url"
                       ],
                       "properties" => %{
                         "path" => %{
                           "type" => "string",
                           "examples" => [
                             "/login"
                           ]
                         },
                         "referrer" => %{
                           "type" => "string",
                           "examples" => [
                             "https://05310947.ngrok.io/organizations"
                           ]
                         },
                         "search" => %{
                           "type" => "string",
                           "examples" => [
                             ""
                           ]
                         },
                         "title" => %{
                           "type" => "string",
                           "examples" => [
                             "login"
                           ]
                         },
                         "url" => %{
                           "type" => "string",
                           "examples" => [
                             "https://05310947.ngrok.io/login"
                           ]
                         }
                       }
                     },
                     "userAgent" => %{
                       "type" => "string",
                       "examples" => [
                         "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36"
                       ]
                     }
                   }
                 },
                 "event" => %{
                   "type" => "string",
                   "examples" => [
                     "invalid event"
                   ]
                 },
                 "integrations" => %{
                   "type" => "object"
                 },
                 "messageId" => %{
                   "type" => "string",
                   "examples" => [
                     "ajs-a11751cec0ebb7ddf26ce32bf236c4eb"
                   ]
                 },
                 "originalTimestamp" => %{
                   "type" => "string",
                   "examples" => [
                     "2019-10-14T23:15:30.079Z"
                   ]
                 },
                 "projectId" => %{
                   "type" => "string",
                   "examples" => [
                     "nAAqhQIKtw"
                   ]
                 },
                 "properties" => %{
                   "type" => "object",
                   "required" => [
                     "email",
                     "userId"
                   ],
                   "properties" => %{
                     "email" => %{
                       "type" => "string",
                       "examples" => [
                         "lui@mag.com"
                       ]
                     },
                     "userId" => %{
                       "type" => "string",
                       "examples" => [
                         "10"
                       ]
                     }
                   }
                 },
                 "receivedAt" => %{
                   "type" => "string",
                   "examples" => [
                     "2019-10-14T23:15:30.202Z"
                   ]
                 },
                 "sentAt" => %{
                   "type" => "string",
                   "examples" => [
                     "2019-10-14T23:15:30.082Z"
                   ]
                 },
                 "timestamp" => %{
                   "type" => "string",
                   "examples" => [
                     "2019-10-14T23:15:30.199Z"
                   ]
                 },
                 "type" => %{
                   "type" => "string",
                   "examples" => [
                     "track"
                   ]
                 },
                 "version" => %{
                   "type" => "number",
                   "examples" => [
                     2
                   ]
                 }
               }
             }

      assert ExJsonSchema.Validator.valid?(infered_schema, @event_map["event_params"])
    end
  end
end
