Howto invoke account customization:
https://docs.aws.amazon.com/controltower/latest/userguide/aft-account-customization-options.html#aft-re-invoke-customizations

goto step functions on aft account, and find
aft-invoke-customizations

##########################################
event schema to invoke audit account, refresh via step function aft-invoke-customization
{
  "include": [
    {
      "type": "accounts",
      "target_value": [ "352190605276" ]
    }
  ]
}

##########################################
example event schema

{
  "include": [
    {
      "type": "all"
    },
    {
      "type": "ous",
      "target_value": [ "ou1","ou2"]
    },
    {
      "type": "tags",
      "target_value": [ {"key1": "value1"}, {"key2": "value2"}]
    },
    {
      "type": "accounts",
      "target_value": [ "acc1_ID","acc2_ID"]
    }
  ],

  "exclude": [
    {
      "type": "ous",
      "target_value": [ "ou1","ou2"]
    },
    {
      "type": "tags",
      "target_value": [ {"key1": "value1"}, {"key2": "value2"}]
    },
    {
      "type": "accounts",
      "target_value": [ "acc1_ID","acc2_ID"]
    }
  ]
}



