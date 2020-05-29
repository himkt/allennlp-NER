// word embedding
local char_embedding_dim = 30;
local pretrained_embedding_file = "https://allennlp.s3.amazonaws.com/datasets/glove/glove.6B.50d.txt.gz";
local embedding_dim = 100;

// character embedding
local window = [3];
local num_filters = 30;
local lstm_hidden_size = 200;

local dropout = 0.5;

// batch
local batch_size = 10;

// optimization
local lr = 0.015;
local momentum = 0.9;
local weight_decay = 0.05;
local gradient_norm = 5.0;

local cuda_device = 0;

{
  "dataset_reader": {
    "type": "conll2003",
    "tag_label": "ner",
    "coding_scheme": "BIOUL",
    "token_indexers": {
      "tokens": {
        "type": "single_id",
        "lowercase_tokens": true
      },
      "token_characters": {
        "type": "characters",
        "min_padding_length": 3
      }
    }
  },
  "train_data_path": "./data/eng.train",
  "validation_data_path": "./data/eng.testa",
  "test_data_path": "./data/eng.testb",
  "model": {
    "type": "crf_tagger",
    "label_encoding": "BIOUL",
    "constrain_crf_decoding": true,
    "calculate_span_f1": true,
    "dropout": dropout,
    "include_start_end_transitions": false,
    "text_field_embedder": {
      "token_embedders": {
        "tokens": {
            "type": "embedding",
            "embedding_dim": embedding_dim,
            "pretrained_file": pretrained_embedding_file,
            "trainable": true
        },
        "token_characters": {
            "type": "character_encoding",
            "embedding": {
                "embedding_dim": char_embedding_dim,
            },
            "encoder": {
                "type": "cnn",
                "embedding_dim": char_embedding_dim,,
                "num_filters": num_filters,
                "ngram_filter_sizes": window,
                "conv_layer_activation": "relu"
            }
          }
       },
    },
    "encoder": {
        "type": "lstm",
        "input_size": embedding_dim + num_filters,
        "hidden_size": lstm_hidden_size,
        "dropout": dropout,
        "bidirectional": true
    },
  },
  "data_loader": {
    "batch_size": batch_size,
  },
  "trainer": {
    "optimizer": {
      "type": "sgd",
      "lr": lr,
      // "momentum": momentum,  TODO (himkt): enabling momentum causes performance problem
      // "weight_decay": weight_decay,
    },
    "checkpointer": {
        "num_serialized_models_to_keep": 3,
    },
    "validation_metric": "+f1-measure-overall",
    "num_epochs": 75,
    "grad_norm": gradient_norm,
    "patience": 25,
    "cuda_device": cuda_device
  }
}
