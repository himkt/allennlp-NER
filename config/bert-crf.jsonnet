// BERT embedding
local bert_embedding_dim = 768;

// FNN
local fnn_hidden_dims = [512, 256];
local fnn_num_layers = 2;
local fnn_activations = "relu";

// Training
local dropout = 0.5;
local batch_size = 32;

// optimization
local optimizer = 'adam';
local lr = 5e-5;
local weight_decay = 0.05;

local cuda_device = 0;

{
  "dataset_reader": {
    "type": "conll2003",
    "tag_label": "ner",
    "coding_scheme": "BIOUL",
    "token_indexers": {
      "tokens": {
        "type": "pretrained_transformer_mismatched",
        "model_name": "neuralmind/bert-base-portuguese-cased",
        "max_length": 512,
      },
    }
  },
  "train_data_path": "./data/eng.train",
  "validation_data_path": "./data/eng.testa",
  "test_data_path": "./data/eng.testb",
  "model": {
    "type": "crf_tagger",
    "label_encoding": "BIOUL",
    "calculate_span_f1": true,
    "text_field_embedder": {
      "token_embedders": {
        "tokens": {
          "type": "pretrained_transformer_mismatched",
          "model_name": "neuralmind/bert-base-portuguese-cased",
          "max_length": 512
        },
      },
    },
    "encoder": {
      "type": "feedforward",
      "feedforward": {
          "input_dim": bert_embedding_dim,
          "hidden_dims": fnn_hidden_dims,
          "num_layers": fnn_num_layers,
          "activations": fnn_activations,
          "dropout": dropout,
      }
    },
  },
  "data_loader": {
    "batch_size": batch_size,
  },
  "trainer": {
    "optimizer": {
      "type": optimizer,
      "lr": lr,
      // "weight_decay": weight_decay,
    },
    "checkpointer": {
      "num_serialized_models_to_keep": 3,
    },
    "validation_metric": "+f1-measure-overall",
    "num_epochs": 75,
    "patience": 25,
    "cuda_device": cuda_device,
  }
}