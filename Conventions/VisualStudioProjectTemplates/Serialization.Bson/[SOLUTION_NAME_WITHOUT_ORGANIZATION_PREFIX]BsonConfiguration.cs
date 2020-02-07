// --------------------------------------------------------------------------------------------------------------------
// <copyright file="[SOLUTION_NAME_WITHOUT_ORGANIZATION_PREFIX]BsonConfiguration.cs" company="Naos Project">
//    Copyright (c) Naos Project 2019. All rights reserved.
// </copyright>
// --------------------------------------------------------------------------------------------------------------------

namespace [PROJECT_NAME]
{
    using System;
    using System.Collections.Generic;
    using OBeautifulCode.Serialization.Bson;

    /// <summary>
    /// Implementation for the <see cref="[SOLUTION_NAME_WITHOUT_ORGANIZATION_PREFIX]" /> domain.
    /// </summary>
    public class [SOLUTION_NAME_WITHOUT_ORGANIZATION_PREFIX]JsonConfiguration : BsonConfigurationBase
    {
        /// <inheritdoc />
        protected override IReadOnlyCollection<Type> TypesToAutoRegister => new[]
        {
        };
    }
}
