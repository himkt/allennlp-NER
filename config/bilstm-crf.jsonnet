local batch_size = 10;
local cuda_device = 0;
local char_embedding_dim = 25;
local char_lstm_hidden_size = 50;
local dropout = 0.5;
local embedding_dim = 100;
local pretrained_embedding_file = "https://allennlp.s3.amazonaws.com/datasets/glove/glove.6B.100d.txt.gz";
local lr = 0.015;
local lstm_hidden_size = 200;
local num_epochs = 150;
local optimizer = "sgd";


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
  "datasets_for_vocab_creation": ["train"],
  "train_data_path": "./data/eng.train",
  "validation_data_path": "./data/eng.testa",
  "test_data_path": "./data/eng.testb",
  "evaluate_on_test": true,
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
                "type": "lstm",
                "input_size": char_embedding_dim,
                "hidden_size": char_lstm_hidden_size/2,
                "bidirectional": true,
            }
          }
       },
    },
    "encoder": {
        "type": "lstm",
        "input_size": embedding_dim + char_lstm_hidden_size,
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
        "type": optimizer,
        "lr": lr,
    },
    "checkpointer": {
        "num_serialized_models_to_keep": 3,
    },
    "validation_metric": "+f1-measure-overall",
    "num_epochs": num_epochs,
    "patience": 25,
    "cuda_device": cuda_device
  }
}
