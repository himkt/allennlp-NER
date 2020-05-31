local cuda_device = 0;
local batch_size = 10;
local bert_embedding_dim = 1024;
local bert_model = "bert-large-cased";
local lr = 5e-7;
local lstm_num_layers = 2;
local lstm_hidden_size = 768;
local max_length = 512
local num_epochs = 150;
local optimizer = 'adam';


{
  "dataset_reader": {
    "type": "conll2003",
    "tag_label": "ner",
    "coding_scheme": "BIOUL",
    "token_indexers": {
      "tokens": {
        "type": "pretrained_transformer_mismatched",
        "model_name": bert_model,
        "max_length": max_length,
      },
    }
  },
  "train_data_path": "./data/eng.train",
  "validation_data_path": "./data/eng.testa",
  "test_data_path": "./data/eng.testb",
  "model": {
    "type": "simple_tagger_2",
    "label_encoding": "BIOUL",
    "calculate_span_f1": true,
    "text_field_embedder": {
      "token_embedders": {
        "tokens": {
          "type": "pretrained_transformer_mismatched",
          "model_name": bert_model,
          "max_length": max_length,
        },
      },
    },
    "encoder": {
        "type": "lstm",
        "input_size": bert_embedding_dim,
        "hidden_size": bert_embedding_dim / 2,
        "dropout": dropout,
        "bidirectional": true,
        "num_layers": lstm_num_layers,
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
    "cuda_device": cuda_device,
  }
}
