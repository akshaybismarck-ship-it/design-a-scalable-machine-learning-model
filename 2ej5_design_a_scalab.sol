Solidity

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract DesignAScalab {
    using SafeMath for uint256;

    // Mapping of model integrators to their respective models
    mapping (address => Model[]) public modelIntegrators;

    // Mapping of models to their respective integrators
    mapping (address => address) public modelToIntegrator;

    // Event emitted when a new model integrator is added
    event NewModelIntegrator(address indexed integrator, address indexed model);

    // Event emitted when a model is updated
    event ModelUpdated(address indexed model, address indexed integrator);

    // Event emitted when a model is removed
    event ModelRemoved(address indexed model, address indexed integrator);

    // Struct to represent a machine learning model
    struct Model {
        address modelAddress;
        string modelName;
        uint256 version;
        uint256 accuracy;
    }

    // Function to add a new model integrator
    function addModelIntegrator(address _integrator, address _model, string memory _modelName, uint256 _version, uint256 _accuracy) public {
        Model memory newModel = Model(_model, _modelName, _version, _accuracy);
        modelIntegrators[_integrator].push(newModel);
        modelToIntegrator[_model] = _integrator;
        emit NewModelIntegrator(_integrator, _model);
    }

    // Function to update a model
    function updateModel(address _model, uint256 _newVersion, uint256 _newAccuracy) public {
        address integrator = modelToIntegrator[_model];
        for (uint256 i = 0; i < modelIntegrators[integrator].length; i++) {
            if (modelIntegrators[integrator][i].modelAddress == _model) {
                modelIntegrators[integrator][i].version = _newVersion;
                modelIntegrators[integrator][i].accuracy = _newAccuracy;
                emit ModelUpdated(_model, integrator);
                return;
            }
        }
    }

    // Function to remove a model
    function removeModel(address _model) public {
        address integrator = modelToIntegrator[_model];
        for (uint256 i = 0; i < modelIntegrators[integrator].length; i++) {
            if (modelIntegrators[integrator][i].modelAddress == _model) {
                modelIntegrators[integrator][i] = modelIntegrators[integrator][modelIntegrators[integrator].length - 1];
                modelIntegrators[integrator].pop();
                delete modelToIntegrator[_model];
                emit ModelRemoved(_model, integrator);
                return;
            }
        }
    }
}