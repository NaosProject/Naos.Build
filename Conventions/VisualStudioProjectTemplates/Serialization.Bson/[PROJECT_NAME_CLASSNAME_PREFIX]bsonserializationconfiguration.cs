// --------------------------------------------------------------------------------------------------------------------
// <copyright file="[PROJECT_NAME_CLASSNAME_PREFIX]BsonSerializationConfiguration.cs" company="Naos Project">
//    Copyright (c) Naos Project 2019. All rights reserved.
// </copyright>
// --------------------------------------------------------------------------------------------------------------------

namespace [PROJECT_NAME]
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Naos.Database.Serialization.Bson;
    using Naos.Protocol.Serialization.Bson;
    using OBeautifulCode.Serialization.Bson;
    using OBeautifulCode.Type;
    using OBeautifulCode.Type.Recipes;

    /// <inheritdoc />
    public class [PROJECT_NAME_CLASSNAME_PREFIX]BsonSerializationConfiguration : BsonSerializationConfigurationBase
    {
        /// <inheritdoc />
        protected override IReadOnlyCollection<string> TypeToRegisterNamespacePrefixFilters =>
            new[]
            {
                [SOLUTION_NAME].Domain.ProjectInfo.Namespace,
            };

        /// <inheritdoc />
        protected override IReadOnlyCollection<BsonSerializationConfigurationType> DependentBsonSerializationConfigurationTypes =>
            new[]
            {
                typeof(ProtocolBsonSerializationConfiguration).ToBsonSerializationConfigurationType(),
                typeof(DatabaseBsonSerializationConfiguration).ToBsonSerializationConfigurationType(),
            };

        /// <inheritdoc />
        protected override IReadOnlyCollection<TypeToRegisterForBson> TypesToRegisterForBson => new Type[0]
            .Concat(new[] { typeof(IModel) })
            .Concat([SOLUTION_NAME].Domain.ProjectInfo.Assembly.GetPublicEnumTypes())
            .Select(_ => _.ToTypeToRegisterForBson())
            .ToList();
    }
}