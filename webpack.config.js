/* eslint-env node */
const path = require("path");
const { CleanWebpackPlugin } = require("clean-webpack-plugin");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

module.exports = async function (_, env) {
  const isProd = env.mode === "production";

  return {
    mode: isProd ? "production" : "development",
    devtool: isProd ? "source-map" : "inline-source-map",
    entry: {
      "edit_template.min": ["./mt-static/plugins/MTMLLinter/src/edit_template.ts"],
    },
    resolve: {
      extensions: [".js", ".jsx", ".ts", ".tsx"],
      modules: ["node_modules", "mt-static/plugins/MTMLLinter/src"],
    },
    externals: {
      jquery: "jQuery",
    },
    plugins: [
      new CleanWebpackPlugin(),
      new MiniCssExtractPlugin({
        filename: "[name].css",
        chunkFilename: "[id].css",
      }),
    ],
    output: {
      path: path.resolve(__dirname, "mt-static/plugins/MTMLLinter/dist"),
      filename: "[name].js",
    },
    module: {
      rules: [
        {
          test: /\.(j|t)sx?$/,
          exclude: /node_modules/,
          use: {
            loader: "babel-loader",
          },
        },
        {
          test: /\.scss$/,
          use: [
            isProd ? MiniCssExtractPlugin.loader : "style-loader",
            { loader: "css-loader", options: { modules: true } },
            { loader: "postcss-loader", options: { sourceMap: isProd } },
          ],
        },
        { test: /\.svg$/, use: "svg-url-loader" },
      ],
    },
    watchOptions: {
      ignored: ["node_modules/**"],
    },
  };
};
