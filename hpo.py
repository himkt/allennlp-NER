from optuna.integration import AllenNLPExecutor
from optuna.integration.allennlp import dump_best_config
from optuna import Trial
from optuna import create_study
from optuna.pruners import HyperbandPruner

config_file = "config/bilstm-cnn-crf-hpo.jsonnet"


def objective(trial: Trial):
    trial.suggest_int("char_embedding_dim", 16, 128)
    trial.suggest_int("lstm_hidden_size", 64, 256)
    trial.suggest_float("lr", 5e-3, 5e-1, log=True)

    executor = AllenNLPExecutor(
        trial=trial,
        config_file=config_file,
        serialization_dir=f"result/{trial.number}",
        metrics="best_validation_f1-measure-overall",
        include_package="allennlp_models",
    )
    return executor.run()


if __name__ == "__main__":
    study = create_study(
        storage="sqlite:///result.db",
        direction="maximize",
        pruner=HyperbandPruner()
    )
    study.optimize(objective)

    dump_best_config(config_file, "hpo.json", study)
