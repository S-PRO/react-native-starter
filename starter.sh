PROJECT_NAME=$1
RN_VERSION=$2


if [ -z "$RN_VERSION" ]
  then react-native init $PROJECT_NAME
else
  react-native init $PROJECT_NAME --version react-native@"$RN_VERSION"
fi

PROJECT_PATH=`cd "$PROJECT_NAME"; pwd`

if [ -e "$PROJECT_PATH/.eslintrc.json" ]
  then echo ".eslintrc.json already exists"
else
  echo "
{
    \"parser\": \"babel-eslint\",
    \"parserOptions\": {
        \"ecmaVersion\": 6,
        \"sourceType\": \"module\",
        \"ecmaFeatures\": {
            \"jsx\": true
        }
    },
    \"env\": {
        \"es6\": true,
        \"jest\": true,
        \"browser\": true,
        \"node\": true
    },
    \"plugins\": [
        \"react\",
        \"jsx-a11y\",
        \"flowtype\"
    ],
    \"rules\": {
        // This to avoid an error from flow types with prefix \`_t_\`
        \"camelcase\": 0,
        // This to avoid an error that all files with jsx must be with extension \`jsx\`
        \"react/jsx-filename-extension\": 0,
        // Avoid error when defined flow types for props at the top of the class
        \"react/sort-comp\": 0,
        // Disable error: absolute imports should come before relative imports.
        \"import/first\": 0,
        // Disable error: do not import modules using an absolute path
        \"import/no-absolute-path\": 0,
        // Allow imports without extensions
        \"import/extensions\": 0,
        // Change error to warning for: prefer default export (when export one item
        // from file - prefer to use \`default export\` instead of \`export\`)
        \"import/prefer-default-export\": 0,
        // disallow trailing commas in object literals
        \"comma-dangle\": 0,
        // Disable rule: strings must use singlequote.
        \"quotes\": 0,
        \"no-console\": [
            \"warn\",
            {
                \"allow\": [
                    \"warn\",
                    \"error\",
                    \"info\"
                ]
            }
        ],
        // Allow to start name of variables and functions from underscore
        \"no-underscore-dangle\": 0,
        // Maximum line length
        \"max-len\": [
            \"warn\",
            120
        ],
        // Disable rule: expected the Promise rejection reason to be an Error.
        // It not allow explicitly return promise reject without error provided
        \"max-lines\": [
          \"warn\",
          300
        ],
        \"prefer-promise-reject-errors\": 0,
        // TODO: find solution for resolve paths for import
        // For now disable error: unable to resolve path to module
        // It be handled by flow
        \"import/no-unresolved\": 0,
        // Allows first line in block to be empty
        \"padded-blocks\": 0,
        // Allow use unary operators
        \"no-plusplus\": 0,
        // Allow to use hasOwnProperty
        \"no-prototype-builtin\": 0,
        // Allow to not define default props for not required props
        \"react/require-default-props\": 0
    },
    \"extends\": [
        \"airbnb\",
        \"plugin:flowtype/recommended\"
    ]
}

" > "$PROJECT_PATH/.eslintrc.json"
fi

cd $PROJECT_PATH

PATH="/usr/local/bin/:$PATH"
FLOW_CONFIG_VERSION=$(tail -n 1 ".flowconfig");

yarn add -D \
babel-eslint \
eslint \
eslint-plugin-react \
eslint-plugin-react-native \
eslint-plugin-jsx-a11y \
husky \
eslint-plugin-import \
eslint-config-airbnb \
flow-bin@$FLOW_CONFIG_VERSION \
eslint-plugin-flowtype

sed -i.bak '/emoji=true/a\
esproposal.decorators=ignore' ".flowconfig"

sed -i.bak '/"scripts": {/a\ 
\    "lint": "eslint ./src",\
\    "flow": "node_modules/.bin/flow",\
\    "precommit": "npm run lint && npm run test",\
\    "prepush": "npm run lint && npm run test",\
' "package.json"


