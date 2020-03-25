// --------------------------------------------------------------------------------------------------------------------
// <copyright file="[SUBSYSTEM_NAME]JsonSerializationConfiguration.cs" company="Naos Project">
//    Copyright (c) Naos Project 2019. All rights reserved.
// </copyright>
// --------------------------------------------------------------------------------------------------------------------

namespace [PROJECT_NAME]
{
    using System;
    using System.Collections.Generic;

    using OBeautifulCode.Serialization.Json;

    /// <inheritdoc />
    public class [SUBSYSTEM_NAME]JsonSerializationConfiguration : JsonConfigurationBase
    {
        /// <inheritdoc />
        protected override IReadOnlyCollection<Type> TypesToAutoRegister => new Type[]
        {
            // ADD TYPES TO REGISTER HERE
        };
    }
}