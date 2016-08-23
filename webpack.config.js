module.exports = {
    entry: './index.js',
    output: {
        path: __dirname,
        filename: "bundle.js"
    },
    module: {
        loaders: [
            { test: /\.css$/, loader: "style!css!" },
            {
                test: /\.elm$/,
                exclude: [/elm-stuff/, /node-modules/],
                loader: "elm"
            }
        ]
    }
}
